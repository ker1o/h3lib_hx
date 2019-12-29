package lib.town;

import lib.res.ResType;
import lib.battle.BattleHex;
import constants.id.CreatureId;
import constants.Alignment;
import constants.BuildingID;
import data.H3mConfigData;
import gui.geometries.Point;
import haxe.Json;
import lib.creature.Creature.Resources;
import lib.mod.IHandlerBase;
import lib.mod.ModHandler;
import lib.mod.VLC;
import lib.StringConstants;
import mapping.TerrainType;

using Reflect;

class TownHandler implements IHandlerBase {
    private static inline var NAMES_PER_TOWN:Int = 16; // number of town names per faction in H3 files.

    public var factions:Array<Faction>;
    public var randomTown:Town;

    private var warMachinesToLoad:Map<Town, Dynamic>;
    private var requirementsToLoad:Array<BuildingRequirementsHelper>;

    public function new() {
        VLC.instance.townh = this;

        factions = [];
        randomTown = new Town();
        warMachinesToLoad = new Map<Town, Dynamic>();
        requirementsToLoad = [];
    }

    public function loadObject(scope:String, name:String, data:Dynamic, index:UInt = 0) {
        var object = loadFromJson(data, ModHandler.normalizeIdentifier(scope, "core", name));
        if (index == 0) {
            index = factions.length;
        }
        object.index = index;
        factions[index] = object;

        if (object.town != null) {
            var info = object.town.clientInfo;
            info.icons[0][0] = 8 + object.index * 4 + 0;
            info.icons[0][1] = 8 + object.index * 4 + 1;
            info.icons[1][0] = 8 + object.index * 4 + 2;
            info.icons[1][1] = 8 + object.index * 4 + 3;

            VLC.instance.modh.identifiers.requestIdentifier(scope, "object", "town", function(index:Int) {
                // register town once objects are loaded
                var config:Dynamic = data.field("town").field("mapObject");
                config.setField("faction", name);
                if (!config.hasField("meta")) {// MODS COMPATIBILITY FOR 0.96
                    config.setField("meta", scope);
                }
                VLC.instance.objtypeh.loadSubObject(object.identifier, config, index, object.index);

                // MODS COMPATIBILITY FOR 0.96
                var advMap:Dynamic = data.field("town").field("adventureMap");
                if (advMap != null) {
                    trace("Outdated town mod. Will try to generate valid templates out of fort");
                    var config:Dynamic = {};
                    config.setField("animation", advMap.field("castle"));
                    VLC.instance.objtypeh.getHandlerFor(index, object.index).addTemplate(config);
                }
            });
        }

        VLC.instance.modh.identifiers.registerObject(scope, "faction", name, object.index);
    }

    private function loadFromJson(source:Dynamic, identifier:String):Faction {
        var faction = new Faction();

        faction.name = source.field("name");
        faction.identifier = identifier;

        faction.creatureBg120 = source.field("creatureBackground").field("120px");
        faction.creatureBg130 = source.field("creatureBackground").field("130px");


        faction.nativeTerrain = (StringConstants.TERRAIN_NAMES.indexOf(source.field("nativeTerrain")):TerrainType);
        faction.alignment = Alignment.parse(source.field("alignment"));

        if (source.hasField("town")) {
            faction.town = new Town();
            faction.town.faction = faction;
            loadTown(faction.town, source.field("town"));
        } else {
            faction.town = null;
        }

        if (source.hasField("puzzleMap")) {
            loadPuzzle(faction, source.field("puzzleMap"));
        }

        return faction;        
    }

    private function loadTown(town:Town, source:Dynamic) {
        var resIndex = StringConstants.RESOURCE_NAMES.indexOf(source.field("primaryResource"));
        if (resIndex == -1) {
            town.primaryRes = ResType.WOOD_AND_ORE; //Wood + Ore
        } else {
            town.primaryRes = (resIndex:ResType);
        }

        warMachinesToLoad.set(town, source.field("warMachine"));

        town.moatDamage = source.field("moatDamage");

        // Compatability for <= 0.98f mods
        if (source.field("moatHexes") == null) {
            town.moatHexes = Town.defaultMoatHexes;
        } else {
            town.moatHexes = (source.field("moatHexes"):Array<BattleHex>);
        }

        town.mageLevel = source.field("mageGuild");
        town.names = (source.field("names"):Array<String>);

        //  Horde building creature level
        var hordeArr:Array<Dynamic> = source.hasField("horde") ? source.field("horde") : [];
        var len:Int = 0;
        for (node in hordeArr) {
            town.hordeLvl.set(len, node);
            len++;
        }

        // town needs to have exactly 2 horde entries. Validation will take care of 2+ entries
        // but anything below 2 must be handled here
        for (i in hordeArr.length...2) {
            town.hordeLvl[i] = -1;
        }

        var creatures:Array<Dynamic> = source.hasField("creatures") ? source.field("creatures") : [];

        for (i in 0...creatures.length) {
            var level:Array<Dynamic> = creatures[i];

            town.creatures[i] = [];

            for (j in 0...level.length) {
                VLC.instance.modh.identifiers.requestIdentifierByNodeName("creature", level[j], "core", function(creature:Int) {
                    town.creatures[i][j] = new CreatureId(creature);
                });
            }
        }

        town.defaultTavernChance = source.field("defaultTavern");
        /// set chance of specific hero class to appear in this town
        var tavernObj:Dynamic = source.field("tavern");
        for (nodeName in tavernObj.fields()) {
            var chance:Int = tavernObj.field(nodeName);

            VLC.instance.modh.identifiers.requestIdentifier(tavernObj.field(nodeName).field("meta"), "heroClass", nodeName, function(classID:Int) {
                VLC.instance.heroh.classes.heroClasses[classID].selectionProbability[town.faction.index] = chance;
            });
        }

        var guildSpellsObj:Dynamic = source.field("guildSpells");
        for (nodeName in guildSpellsObj.fields()) {
            var chance:Int = guildSpellsObj.field(nodeName);

            VLC.instance.modh.identifiers.requestIdentifier(tavernObj.field(nodeName).field("meta"), "spell", nodeName, function(spellID:Int) {
                VLC.instance.spellh.objects[spellID].probabilities[town.faction.index] = chance;
            });
        }

        var dwellingsArr:Array<Dynamic> = source.field("adventureMap").field("dwellings");
        if(dwellingsArr != null) {
            for(d in dwellingsArr) {
                town.dwellings.push(d.field("graphics"));
                town.dwellingNames.push(d.field("name"));
            }
        }

        loadBuildings(town, source.field("buildings"));
        loadClientData(town, source);
    }

    private function loadBuildings(town:Town, source:Dynamic) {
        for(nodeName in source.fields()) {
            if (source.field(nodeName) != null) {
                loadBuilding(town, nodeName, source.field(nodeName));
            }
        }
    }

    private function loadBuilding(town:Town, stringId:String, source:Dynamic) {
        var ret = new Building();

        var MODES = ["normal", "auto", "special", "grail"];

        ret.mode = BuildMode.BUILD_NORMAL;
        {
            if(Std.is(source.field("mode"), String)) {
                var rawModeIndex = MODES.indexOf(source.field("mode"));
                if(rawModeIndex > -1) {
                    ret.mode = (rawModeIndex:BuildMode);
                }
            }
        }

        ret.identifier = stringId;
        ret.town = town;
        ret.bid = (source.field("id"):BuildingID);
        ret.name = source.field("name");
        ret.description = source.field("description");
        ret.resources = (source.field("cost"):Resources);
        ret.produce =   (source.field("produce"):Resources);

/*	//MODS COMPATIBILITY FOR 0.96
	if(!ret.produce.nonZero())
	{
		switch (ret.bid) {
			case BuildingID.VILLAGE_HALL: ret.produce[Res.GOLD] = 500;
			case BuildingID.TOWN_HALL :   ret.produce[Res.GOLD] = 1000;
			case BuildingID.CITY_HALL :   ret.produce[Res.GOLD] = 2000;
			case BuildingID.CAPITOL :     ret.produce[Res.GOLD] = 4000;
			case BuildingID.GRAIL :       ret.produce[Res.GOLD] = 5000;
			case BuildingID.RESOURCE_SILO :
			{
				switch (ret.town.primaryRes)
				{
					case Res.GOLD:
						ret.produce[ret.town.primaryRes] = 500;
					case Res.WOOD_AND_ORE:
						ret.produce[Res.WOOD] = 1;
						ret.produce[Res.ORE] = 1;
					default:
						ret.produce[ret.town.primaryRes] = 1;
				}
			}
		}
	}
*/
        loadBuildingRequirements(ret, source.field("requires"));

        if (source.field("upgrades") != null) {
            // building id and upgrades can't be the same
            if(stringId == source.field("upgrades")) {
                throw 'Building with ID "$stringId" of town "${ret.town.getFactionName()}" can\'t be an upgrade of the same building.';
            }

            VLC.instance.modh.identifiers.requestIdentifierByNodeName(ret.town.getBuildingScope(), source.field("upgrades"), "core", function (identifier:Int) {
                ret.upgrade = (identifier:BuildingID);
            });
        } else {
            ret.upgrade = BuildingID.NONE;
        }

        ret.town.buildings.set(ret.bid, ret);

        VLC.instance.modh.identifiers.registerObject(source.field("meta"), ret.town.getBuildingScope(), ret.identifier, ret.bid);
    }

    private function loadBuildingRequirements(building:Building, source:Dynamic) {
        if (source == null) return;

        var hlp = new BuildingRequirementsHelper();
        hlp.building = building;
        hlp.town = building.town;
        hlp.json = source;
        requirementsToLoad.push(hlp);
    }

    private static function readIcon(source:Dynamic, info:ClientInfo, x:Int, y:Int) {
        if(source != null) {
            info.iconSmall[x][y] = source.field("small");
            info.iconLarge[x][y] = source.field("large");
        }
    }

    private function loadClientData(town:Town, source:Dynamic) {
        var info:ClientInfo = town.clientInfo;

        readIcon(source.field("icons").field("village").field("normal"), info, 0, 0);
        readIcon(source.field("icons").field("village").field("built"), info, 0, 1);
        readIcon(source.field("icons").field("fort").field("normal"), info, 1, 0);
        readIcon(source.field("icons").field("fort").field("built"), info, 1, 1);

        info.hallBackground = source.field("hallBackground");
        info.musicTheme = source.field("musicTheme");
        info.townBackground = source.field("townBackground");
        info.guildWindow = source.field("guildWindow");
        info.buildingsIcons = source.field("buildingsIcons");

        //left for back compatibility - will be removed later
        if (source.field("guildBackground") != "") {
            info.guildBackground = source.field("guildBackground");
        } else {
            info.guildBackground = "TPMAGE.bmp";
        }

        if (source.field("tavernVideo") != "") {
            info.tavernVideo = source.field("tavernVideo");
        } else {
            info.tavernVideo = "TAVERN.BIK";
        }
        //end of legacy assignment

        loadTownHall(town, source.field("hallSlots"));
        loadStructures(town, source.field("structures"));
        loadSiegeScreen(town, source.field("siege"));
    }

    private function loadTownHall(town:Town, source:Dynamic) {
        var dstSlots = town.clientInfo.hallSlots;
        var srcSlots:Array<Dynamic> = source != null ? source : [];

        for(i in 0...srcSlots.length) {
            var dstRow = [];
            var srcRow:Array<Dynamic> = srcSlots[i];

            for(j in 0...srcRow.length) {
                var dstBox = [];
                var srcBox:Array<Dynamic> = srcRow[j];

                for(k in 0...srcBox.length) {
                    var src = srcBox[k];

                    VLC.instance.modh.identifiers.requestIdentifierByNodeName("building." + town.faction.identifier, src, "core", function(identifier:Int) {
                        dstBox[k] = (identifier:BuildingID);
                    });
                }
                dstRow[j] = dstBox;
            }
            dstSlots[i] = dstRow;
        }
    }

    private function loadStructures(town:Town, source:Dynamic) {
        for(nodeName in source.fields()) {
            if (source.field(nodeName) != null) {
                loadStructure(town, nodeName, source.field(nodeName));
            }
        }
    }

    private function loadStructure(town:Town, stringId:String, source:Dynamic) {
        var ret = new Structure();

        ret.building = null;
        ret.buildable = null;

        VLC.instance.modh.identifiers.tryRequestIdentifier(source.field("meta"), "building." + town.faction.identifier, stringId, function (identifier:Int) {
            ret.building = town.buildings[(identifier:BuildingID)];
        });

        if (source.field("builds") == null) {
            VLC.instance.modh.identifiers.tryRequestIdentifier(source.field("meta"), "building." + town.faction.identifier, stringId, function(identifier:Int) {
                ret.building = town.buildings[(identifier:BuildingID)];
            });
        } else {
            VLC.instance.modh.identifiers.requestIdentifierByNodeName("building." + town.faction.identifier, source.field("builds"), "core", function(identifier:Int) {
                ret.buildable = town.buildings[(identifier:BuildingID)];
            });
        }

        ret.identifier = stringId;
        ret.pos.x = source.field("x");
        ret.pos.y = source.field("y");
        ret.pos.z = source.field("z");

        ret.hiddenUpgrade = source.field("hidden");
        ret.defName = source.field("animation");
        ret.borderName = source.field("border");
        ret.areaName = source.field("area");

        town.clientInfo.structures.push(ret);
    }

    private function loadSiegeScreen(town:Town, source:Dynamic) {
        function jsonToPoint(source:Dynamic):Point {
            return new Point(source.field("x"), source.field("y"));
        }

        if (source == null) return;

        town.clientInfo.siegePrefix = source.field("imagePrefix");
        VLC.instance.modh.identifiers.requestIdentifierByNodeName("creature", source.field("shooter"), "core", function(creature:Int) {
            town.clientInfo.siegeShooter = new CreatureId(creature);
        });

        var pos:Array<Point> = town.clientInfo.siegePositions;

        pos[8]  = jsonToPoint(source.field("towers").field("top").field("tower"));
        pos[17] = jsonToPoint(source.field("towers").field("top").field("battlement"));
        pos[20] = jsonToPoint(source.field("towers").field("top").field("creature"));

        pos[2]  = jsonToPoint(source.field("towers").field("keep").field("tower"));
        pos[15] = jsonToPoint(source.field("towers").field("keep").field("battlement"));
        pos[18] = jsonToPoint(source.field("towers").field("keep").field("creature"));

        pos[3]  = jsonToPoint(source.field("towers").field("bottom").field("tower"));
        pos[16] = jsonToPoint(source.field("towers").field("bottom").field("battlement"));
        pos[19] = jsonToPoint(source.field("towers").field("bottom").field("creature"));

        pos[9]  = jsonToPoint(source.field("gate").field("gate"));
        pos[10]  = jsonToPoint(source.field("gate").field("arch"));

        pos[7]  = jsonToPoint(source.field("walls").field("upper"));
        pos[6]  = jsonToPoint(source.field("walls").field("upperMid"));
        pos[5]  = jsonToPoint(source.field("walls").field("bottomMid"));
        pos[4]  = jsonToPoint(source.field("walls").field("bottom"));

        pos[13] = jsonToPoint(source.field("moat").field("moat"));
        pos[14] = jsonToPoint(source.field("moat").field("bank"));

        pos[11] = jsonToPoint(source.field("static").field("bottom"));
        pos[12] = jsonToPoint(source.field("static").field("top"));
        pos[1]  = jsonToPoint(source.field("static").field("background"));
    }

    private function loadPuzzle(faction:Faction, source:Dynamic) {
        var prefix = source.field("prefix");
        var piecesArr:Array<Dynamic> = source.field("pieces");
        for(piece in piecesArr) {
            var index:Int = faction.puzzleMap.length;
            var spi = new PuzzleInfo();

            spi.x = piece.field("x");
            spi.y = piece.field("y");
            spi.whenUncovered = piece.field("index");
            spi.number = index;

            // filename calculation
            //ToDo:check if it is correct
            var suffix = index < 10 ? '0' + index : Std.string(index);

            spi.filename = prefix + suffix;

            faction.puzzleMap.push(spi);
        }
    }

    public function loadLegacyData(dataSize:Int):Array<Dynamic> {
        var dest:Array<Dynamic> = [];
        // init
        for (town in 0...dataSize) {
            dest[town] = {town: {buildings: {}}};
        }

        function getBuild(town:UInt, building:UInt):Dynamic {
            var buildingsData:Dynamic = dest[town].field("town").field("buildings");
            var buildingType:String = StringConstants.BUILDING_TYPE[building];

            var build:Dynamic = null;
            if (buildingsData.hasField(buildingType)) {
                build = buildingsData.field(buildingType);
            } else {
                build = {};
                buildingsData.setField(buildingType, build);
            }
            return build;
        }

        var parser:Dynamic = Json.parse(H3mConfigData.data.get("DATA/BUILDING.TXT"));

        //Unique buildings
        var specialsObj = parser.field("unique");
        for (town in 0...dataSize) {
            var castleBuildingsObj:Array<Dynamic> = specialsObj[town];
            var buildID = 17;

            for (buildingObj in castleBuildingsObj) {
                readBuilding(getBuild(town, buildID), buildingObj);
                buildID++;
            }
        }

        // Common buildings
        var buildID = 0;
        var commonObj:Array<Dynamic> = parser.field("common");

        for (buildingObj in commonObj) {
            var building:Dynamic = {};
            readBuilding(building, buildingObj);
            for (town in 0...dataSize) {
                getBuild(town, buildID).setField("cost", building.field("cost"));
            }

            buildID++;
        }

        //Dwellings
        var dwellingsObj:Array<Array<Dynamic>> = parser.field("dwellings");
        for (town in 0...dataSize) {
            for (i in 0...14) {
                readBuilding(getBuild(town, 30 + i), dwellingsObj[town][i]);
            }
        }

        parser = Json.parse(H3mConfigData.data.get("DATA/BLDGNEUT.TXT"));
        var pos:Int = 0;
        for (building in 0...15) {
            var name:String  = parser[pos][0];
            var descr:String = parser[pos][1];

            for(j in 0...dataSize) {
                getBuild(j, building).setField("name", name);
                getBuild(j, building).setField("description", descr);
            }
            pos++;
        }

        pos++; //blacksmith  //unused entries
        pos++; //moat

        //shipyard with the ship
        var name:String  = parser[pos][0];
        var descr:String = parser[pos][1];
        for(town in 0...dataSize) {
            getBuild(town, 20).setField("name", name);
            getBuild(town, 20).setField("description", descr);
        }
        pos++;

        //blacksmith
        for(town in 0...dataSize) {
            getBuild(town, 16).setField("name", parser[pos][0]);
            getBuild(town, 16).setField("description", parser[pos][1]);
            pos++;
        }


        parser = Json.parse(H3mConfigData.data.get("DATA/BLDGSPEC.TXT"));
        pos = 0;
        for(town in 0...dataSize) {
            for(build in 0...9) {
                getBuild(town, 17 + build).setField("name", parser[pos][0]);
                getBuild(town, 17 + build).setField("description", parser[pos][1]);
                pos++;
            }
            getBuild(town, 26).setField("name", parser[pos][0]); // Grail
            getBuild(town, 26).setField("description", parser[pos][1]);
            pos++;

            getBuild(town, 15).setField("name", parser[pos][0]); // Resource silo
            getBuild(town, 15).setField("description", parser[pos][1]);
            pos++;
        }


        parser = Json.parse(H3mConfigData.data.get("DATA/DWELLING.TXT"));
        pos = 0;
        for(town in 0...dataSize) {
            for(build in 0...14) {
                getBuild(town, 30 + build).setField("name", parser[pos][0]);
                getBuild(town, 30 + build).setField("description", parser[pos][1]);
                pos++;
            }
        }


        var typeParser:Array<Dynamic> = Json.parse(H3mConfigData.data.get("DATA/TOWNTYPE.TXT"));
        var nameParser = Json.parse(H3mConfigData.data.get("DATA/TOWNNAME.TXT"));
        pos = 0;
        var townID = 0;
        var nameIndex = 0;
        for(type in typeParser) {
            dest[townID].setField("name", type);
            var namesObj = [];
            for(i in 0...NAMES_PER_TOWN) {
                namesObj.push(nameParser[nameIndex++]);
            }
            dest[townID].setField("names", namesObj);
        }

        return dest;
    }

    private function readBuilding(refObj:Dynamic, parser:Array<Dynamic>) {
        var costObj:Dynamic = {};
        var pos = 0;

        //note: this code will try to parse mithril as well but wil always return 0 for it
        for(resId in StringConstants.RESOURCE_NAMES) {
            try {
                costObj.setField(resId, parser[pos++]);
            }catch(e:Dynamic) {
                trace("");
            }
        }
        costObj.deleteField("mithril");

        refObj.setField("cost", costObj);
    }
}
