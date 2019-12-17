package lib.artifacts;

import constants.ArtifactId;
import constants.Obj;
import lib.mod.ModHandler;
import lib.artifacts.Artifact.ArtClass;
import lib.artifacts.Artifact.ArtBearer;
import constants.ArtifactPosition;
import constants.CreatureType;
import lib.herobonus.Bonus;
import constants.id.CreatureId;
import utils.JsonUtils;
import lib.mod.VLC;
import data.H3mConfigData;
import haxe.Json;
import lib.mod.IHandlerBase;

using Reflect;

class ArtHandler implements IHandlerBase {
    //tmp vectors!!! do not touch if you don't know what you are doing!!!
    public var treasures:Array<Artifact>;
    public var minors:Array<Artifact>;
    public var majors:Array<Artifact>;
    public var relics:Array<Artifact>;

    public var artifacts:Array<Artifact>;
    public var allowedArtifacts:Array<Artifact>;
    public var growingArtifacts:Array<Artifact>;

    public function new() {
        artifacts = [];
    }

    public function loadObject(scope:String, name:String, data:Dynamic, index:UInt = 0) {
        var object = loadFromJson(data, ModHandler.normalizeIdentifier(scope, "core", name));
        if(index == 0) {
            index = artifacts.length;
        }
        object.id = (index:ArtifactId);
        object.iconIndex = object.id + 5;

        artifacts[index] = object;

        VLC.instance.modh.identifiers.requestIdentifier(scope, "object", "artifact", function(index:Int)
        {
            var conf:Dynamic = {};
            conf.setField("meta", scope);

            VLC.instance.objtypeh.loadSubObject(object.identifier, conf, Obj.ARTIFACT, object.id);

            if (object.advMapDef != null && object.advMapDef != "") {
                var templ:Dynamic = {};
                templ.setField("meta", scope);
                templ.setField("animation", object.advMapDef);

                // add new template.
                // Necessary for objects added via mods that don't have any templates in H3
                VLC.instance.objtypeh.getHandlerFor(Obj.ARTIFACT, object.id).addTemplate(templ);
            }
                // object does not have any templates - this is not usable object (e.g. pseudo-art like lock)
            if (VLC.instance.objtypeh.getHandlerFor(Obj.ARTIFACT, object.id).getTemplates().length == 0) {
                VLC.instance.objtypeh.removeSubObject(Obj.ARTIFACT, object.id);
            }
        });

        VLC.instance.modh.identifiers.registerObject(scope, "artifact", name, object.id);
    }

    public function loadFromJson(node:Dynamic, identifier:String):Artifact {
        var art:Artifact;

        if (VLC.instance.modh.modules.COMMANDERS == false || node.field("growing") == null) {
            art = new Artifact();
        } else {
            var growing = new GrowingArtifact();
            loadGrowingArt(growing, node);
            art = growing;
        }
        art.identifier = identifier;
        var text:Dynamic = node.field("text");
        art.name        = text.field("name");
        art.description = text.field("description");
        art.eventText   = text.field("event");

        var graphics:Dynamic = node.field("graphics");
        art.image = graphics.field("image");

        if (graphics.field("large") != null) {
            art.large = graphics.field("large");
        } else {
            art.large = art.image;
        }

        art.advMapDef = graphics.field("map");

        art.price = node.field("value");

        loadSlots(art, node);
        loadClass(art, node);
        loadType(art, node);
        loadComponents(art, node);

        if (node.hasField("bonuses")) {
            var bonuses:Array<Dynamic> = node.field("bonuses");
            for (b in bonuses) {
                var bonus = JsonUtils.parseBonus(b);
                art.addNewBonus(bonus);
            }
        }

        var warMachine:Dynamic = node.field("warMachine");
        if(Std.is(warMachine, String) && warMachine != "") {
            VLC.instance.modh.identifiers.requestIdentifierByNodeName("creature", warMachine, "core", function(id:Int) {
                art.warMachine = new CreatureId((id:CreatureType));

                //this assumes that creature object is stored before registration
                VLC.instance.creh.creatures[id].warMachine = art.id;
            });
        }

        return art;
    }

    private function loadGrowingArt(art:GrowingArtifact, node:Dynamic) {
        var bonusesPerLevel:Array<Dynamic> = node.field("growing").field("bonusesPerLevel");
        for (b in bonusesPerLevel) {
            var bonus = JsonUtils.parseBonus(b.field("bonus"));
            art.bonusesPerLevel.push({level: b.field("level"), bonus: bonus});
        }
        var thresholdBonuses:Array<Dynamic> = node.field("growing").field("thresholdBonuses");
        for (b in thresholdBonuses) {
            var bonus = JsonUtils.parseBonus(b.field("bonus"));
            art.thresholdBonuses.push({level: b.field("level"), bonus: bonus});
        }
    }

    private function loadSlots(art:Artifact, node:Dynamic) {
        if (node.field("slot") != null) { //we assume non-hero slots are irrelevant?
            if (Std.is(node.field("slot"), String)) {
                addSlot(art, (node.field("slot"):String));
            } else {
                var slots:Array<Dynamic> = node.field("slot");
                for (slot in slots) {
                    addSlot(art, Std.string(slot));
                }
            }
        }
    }

    function stringToSlot(slotName:String):ArtifactPosition {
        var artPosition = ArtifactPosition.parseString(slotName);
        if (artPosition != ArtifactPosition.UNKNOWN) {
            return artPosition;
        }

        trace('Warning! Artifact slot $slotName not recognized!');
        return ArtifactPosition.PRE_FIRST;
    }

    private static var miscSlots:Array<ArtifactPosition> = [ArtifactPosition.MISC1, ArtifactPosition.MISC2, ArtifactPosition.MISC3, ArtifactPosition.MISC4, ArtifactPosition.MISC5];
    private static var ringSlots:Array<ArtifactPosition> = [ArtifactPosition.LEFT_RING, ArtifactPosition.RIGHT_RING];

    private function addSlot(art:Artifact, slotID:String) {
        if (!art.possibleSlots.exists(ArtBearer.HERO)) {
            art.possibleSlots.set(ArtBearer.HERO, []);
        }
        if (slotID == "MISC") {
            for (el in miscSlots) {
                art.possibleSlots.get(ArtBearer.HERO).push(el);
            }
        } else if (slotID == "RING") {
            for (el in ringSlots) {
                art.possibleSlots.get(ArtBearer.HERO).push(el);
            }
        } else {
            var slot = stringToSlot(slotID);
            if (slot != ArtifactPosition.PRE_FIRST) {
                art.possibleSlots.get(ArtBearer.HERO).push(slot);
            }
        }
    }

    private static var artifactClassMap:Map<String, ArtClass> = [
        "TREASURE" => ArtClass.ART_TREASURE,
        "MINOR" => ArtClass.ART_MINOR,
        "MAJOR" => ArtClass.ART_MAJOR,
        "RELIC" => ArtClass.ART_RELIC,
        "SPECIAL" => ArtClass.ART_SPECIAL
    ];

    private function stringToClass(className:String) {
        if (artifactClassMap.exists(className)) {
            return artifactClassMap.get(className);
        }

        trace('Warning! Artifact rarity $className not recognized!');
        return ArtClass.ART_SPECIAL;
    }

    private function loadClass(art:Artifact, node:Dynamic) {
        art.aClass = stringToClass(Std.string(node.field("class")));
    }

    private function clearPossibleSlots(possibleSlots:Map<ArtBearer, Array<Dynamic>>, name:ArtBearer) {
        if (!possibleSlots.exists(name)) {
            possibleSlots.set(name, []);
        } else {
            var tempArr = possibleSlots.get(name);
            while (tempArr.length > 0) {
                tempArr.pop();
            }
        }
    }

    private function makeItCommanderArt(a:Artifact, onlyCommander:Bool = true) {
        if (onlyCommander) {
            clearPossibleSlots(a.possibleSlots, ArtBearer.HERO);
            clearPossibleSlots(a.possibleSlots, ArtBearer.CREATURE);
        }

        if (!a.possibleSlots.exists(ArtBearer.COMMANDER)) {
            a.possibleSlots.set(ArtBearer.COMMANDER, []);
        }
        for (i in ArtifactPosition.COMMANDER1...(ArtifactPosition.COMMANDER6 + 1)) {
            a.possibleSlots.get(ArtBearer.COMMANDER).push((i:ArtifactPosition));
        }
    }

    private function makeItCreatureArt(a:Artifact, onlyCreature:Bool = true) {
        if (onlyCreature) {
            clearPossibleSlots(a.possibleSlots, ArtBearer.HERO);
            clearPossibleSlots(a.possibleSlots, ArtBearer.COMMANDER);
        }
        if (!a.possibleSlots.exists(ArtBearer.CREATURE)) {
            a.possibleSlots.set(ArtBearer.CREATURE, []);
        }
        a.possibleSlots.get(ArtBearer.CREATURE).push(ArtifactPosition.CREATURE_SLOT);
    }

    private function loadType(art:Artifact, node:Dynamic) {
        var artifactBearherMap:Map<String, Int> = [
            "HERO" => ArtBearer.HERO,
            "CREATURE" => ArtBearer.CREATURE,
            "COMMANDER" => ArtBearer.COMMANDER
        ];

        var types:Array<String> = node.field("type");
        for (type in types) {
            if (artifactBearherMap.exists(type)) {
                var bearerType:Int = artifactBearherMap.get(type);
                switch (bearerType) {
                    case ArtBearer.HERO: //TODO: allow arts having several possible bearers
                    case ArtBearer.COMMANDER:
                        makeItCommanderArt(art); //original artifacts should have only one bearer type
                    case ArtBearer.CREATURE:
                        makeItCreatureArt(art);
                }
            }
            else {
                trace('Warning! Artifact type $type not recognized!');
            }
        }
    }

    private function loadComponents(art:Artifact, node:Dynamic) {
        if (node.hasField("components")) {
            art.constituents = [];
            var components:Array<Dynamic> = node.field("components");
            for (component in components) {
                VLC.instance.modh.identifiers.requestIdentifierByNodeName("artifact", component, "core", function(id:Int) {
                    // when this code is called both combinational art as well as component are loaded
                    // so it is safe to access any of them
                    art.constituents.push(VLC.instance.arth.artifacts[id]);
                    VLC.instance.arth.artifacts[id].constituentOf.push(art);
                });
            }
        }
    }

    public function loadLegacyData(dataSize:Int):Array<Dynamic> {
        var h3Data:Array<Dynamic> = [];

        var classes = [
            "S" => "SPECIAL",
            "T" => "TREASURE",
            "N" => "MINOR",
            "J" => "MAJOR",
            "R" => "RELIC"
        ];
        var artSlots = ["SPELLBOOK", "MACH4", "MACH3", "MACH2", "MACH1", "MISC5", "MISC4", "MISC3", "MISC2", "MISC1", "FEET", "LEFT_RING", "RIGHT_RING", "TORSO", "LEFT_HAND", "RIGHT_HAND", "NECK", "SHOULDERS", "HEAD"];

        var parser:Array<Array<Dynamic>> = Json.parse(H3mConfigData.data.get("DATA/ARTRAITS.TXT"));
        var events:Array<String> = Json.parse(H3mConfigData.data.get("DATA/ARTEVENT.TXT"));

        for(i in 0...dataSize) {
            var parserData = parser[i];
            var artData = {};
            var pos:Int = 0;
            var text = {name: parserData[pos++], event: events[i]};
            Reflect.setField(artData, "value", parserData[pos++]);

            var slotData:Array<String> = [];
            for(artSlot in artSlots) {
                if(parserData[pos++] == true) {
                    slotData.push(artSlot);
                }
            }

            Reflect.setField(artData, "slot", slotData);
            Reflect.setField(artData, "class", classes.get(parserData[pos++]));
            Reflect.setField(artData, "description", parserData[pos++]);
            Reflect.setField(artData, "text", text);

            h3Data.push(artData);
        }

        return h3Data;
    }

}
