package lib.town;

import lib.mod.ModHandler;
import haxe.Json;
import data.H3mConfigData;
import lib.mod.IHandlerBase;
import lib.mod.VLC;
import lib.StringConstants;

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
    }

    public function loadObject(scope:String, name:String, data:Dynamic, index:UInt = 0) {
        var object = loadFromJson(data, ModHandler.normalizeIdentifier(scope, "core", name));
        if (index == 0) {
            index = factions.length;
        }
        object.index = index;
        factions[index] = factions;

        // ToDo me
    }

    private function loadFromJson():Faction {
        var faction = new Faction();
        // ToDo me
        return faction;
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
