package lib.hero;

import lib.filesystem.FileCache;
import lib.mod.IHandlerBase;
import lib.mod.ModHandler;
import lib.mod.VLC;

using Reflect;

class HeroClassHandler implements IHandlerBase {
    public var heroClasses:Array<HeroClass>;

    public function new() {
        heroClasses = [];
    }

    public function loadObject(scope:String, name:String, data:Dynamic, index:UInt = 0) {
        var object = loadFromJson(data, ModHandler.normalizeIdentifier(scope, "core", name));
        if (index == 0) {
            index = heroClasses.length;
        }
        object.id = index;

        heroClasses[index] = object;

        VLC.instance.modh.identifiers.requestIdentifier(scope, "object", "hero", function(index:Int) {
            var classConf:Dynamic = data.field("mapObject");
            classConf.setField("heroClass", name);
            classConf.setField("meta", scope);
            VLC.instance.objtypeh.loadSubObject(name, classConf, index, object.id);
        });

        VLC.instance.modh.identifiers.registerObject(scope, "heroClass", name, object.id);
    }

    private function loadFromJson(node:Dynamic, identifier:String):HeroClass {
        var affinityStr:Array<String> = ["might", "magic"];

        var heroClass = new HeroClass();
        heroClass.identifier = identifier;
        heroClass.imageBattleFemale = node.field("animation").field("battle").field("female");
        heroClass.imageBattleMale   = node.field("animation").field("battle").field("male");
        //MODS COMPATIBILITY FOR 0.96
        heroClass.imageMapFemale    = node.field("animation").field("map").field("female");
        heroClass.imageMapMale      = node.field("animation").field("map").field("male");

        heroClass.name = node.field("name");
        heroClass.affinity = (affinityStr.indexOf(node.field("affinity")):ClassAffinity);

        for(pSkill in StringConstants.PRIMARY_SKILLS) {
            heroClass.primarySkillInitial.push(node.field("primarySkills").field(pSkill));
            heroClass.primarySkillLowLevel.push(node.field("lowLevelChance").field(pSkill));
            heroClass.primarySkillHighLevel.push(node.field("highLevelChance").field(pSkill));
        }

        var secondarySkillsObj:Dynamic = node.field("secondarySkills");
        for(skillPairKey in secondarySkillsObj.fields()) {
            var probability:Int = secondarySkillsObj.field(skillPairKey);
            VLC.instance.modh.identifiers.requestIdentifier("core", "skill", skillPairKey, function(skillID:Int) { // [heroClass, probability] must be captured
                if(heroClass.secSkillProbability.length <= skillID) {
                    for (i in heroClass.secSkillProbability.length...(skillID + 1)) {
                        heroClass.secSkillProbability.push(-1); // -1 = override with default later
                    }
                }
                heroClass.secSkillProbability[skillID] = probability;
            });
        }

        VLC.instance.modh.identifiers.requestIdentifierByNodeName("creature", node.field("commander"), "core", function(commanderID:Int) {
            heroClass.commander = VLC.instance.creh.creatures[commanderID];
        });

        heroClass.defaultTavernChance = node.field("defaultTavern");
        var tavernObj:Dynamic = node.field("tavern");
        for(tavernKey in tavernObj.fields()) {
            var value:Int = tavernObj.field(tavernKey);

            VLC.instance.modh.identifiers.requestIdentifier("core", "faction", tavernKey, function(factionID:Int) {
                heroClass.selectionProbability[factionID] = value;
            });
        }

        VLC.instance.modh.identifiers.requestIdentifierByNodeName("faction", node.field("faction"), "core", function(factionID:Int) {
            heroClass.faction = factionID;
        });

        return heroClass;
    }

    public function loadLegacyData(dataSize:Int):Array<Dynamic> {
        var h3Data:Array<Dynamic> = [];
        var parser = FileCache.instance.getConfig("DATA/HCTRAITS.TXT");

        for(i in 0...dataSize) {
            var parserData = parser[i];
            var pos = 0;
            var entry = {};
            Reflect.setField(entry, "name", parserData[pos++]);

            var innerObj = {};
            for(skillName in StringConstants.PRIMARY_SKILLS) {
                Reflect.setField(innerObj, skillName, parserData[pos++]);
            }
            Reflect.setField(entry, "primarySkills", innerObj);

            innerObj = {};
            for(skillName in StringConstants.PRIMARY_SKILLS) {
                Reflect.setField(innerObj, skillName, parserData[pos++]);
            }
            Reflect.setField(entry, "lowLevelChance", innerObj);

            innerObj = {};
            for(skillName in StringConstants.PRIMARY_SKILLS) {
                Reflect.setField(innerObj, skillName, parserData[pos++]);
            }
            Reflect.setField(entry, "highLevelChance", innerObj);

            innerObj = {};
            for(skillName in StringConstants.SECONDARY_SKILLS_NAMES) {
                Reflect.setField(innerObj, skillName, parserData[pos++]);
            }
            Reflect.setField(entry, "secondarySkills", innerObj);

            innerObj = {};
            for(skillName in StringConstants.TOWN_TYPE) {
                Reflect.setField(innerObj, skillName, parserData[pos++]);
            }
            Reflect.setField(entry, "tavern", innerObj);

            h3Data.push(entry);
        }

        return h3Data;
    }
}