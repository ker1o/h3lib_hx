package;

import constants.GameConstants;
import constants.BuildingID;

class BuildingHandler {
    private static var _campToERMU:Array<BuildingID> = [
        BuildingID.TOWN_HALL, BuildingID.CITY_HALL,
        BuildingID.CAPITOL, BuildingID.FORT, BuildingID.CITADEL, BuildingID.CASTLE, BuildingID.TAVERN,
        BuildingID.BLACKSMITH, BuildingID.MARKETPLACE, BuildingID.RESOURCE_SILO, BuildingID.NONE,
        BuildingID.MAGES_GUILD_1, BuildingID.MAGES_GUILD_2, BuildingID.MAGES_GUILD_3, BuildingID.MAGES_GUILD_4,
        BuildingID.MAGES_GUILD_5,
        BuildingID.SHIPYARD, BuildingID.GRAIL,
        BuildingID.SPECIAL_1, BuildingID.SPECIAL_2, BuildingID.SPECIAL_3, BuildingID.SPECIAL_4
    ];

    static var hordeLvlsPerTType = [[2], [1], [1,4], [0,2], [0], [0], [0], [0], [0]];

    public function new() {

    }

    public static function campToERMU(camp:Int, townType:Int, builtBuildings:Array<BuildingID>):BuildingID {
        if (camp < _campToERMU.length) {
            return _campToERMU[camp];
        }

        var curPos = _campToERMU.length;
        for (i in 0...GameConstants.CREATURES_PER_TOWN) {
            if(camp == curPos) //non-upgraded
                return ((30 + i):BuildingID);
            curPos++;
            if(camp == curPos) //upgraded
                return ((37 + i):BuildingID);
            curPos++;

            if (i < 5) {// last two levels don't have reserved horde ID. Yet another H3C weirdeness
                if (hordeLvlsPerTType[townType].indexOf(i) > -1) {
                    if (camp == curPos) {
                        if (hordeLvlsPerTType[townType][0] == i) {
                            if (builtBuildings.indexOf(37 + hordeLvlsPerTType[townType][0]) > -1) {//if upgraded dwelling is built
                                return BuildingID.HORDE_1_UPGR;
                            } else {//upgraded dwelling not presents
                                return BuildingID.HORDE_1;
                            }
                        } else {
                            if (hordeLvlsPerTType[townType].length > 1) {
                                if (builtBuildings.indexOf(37 + hordeLvlsPerTType[townType][1]) > -1) {//if upgraded dwelling is built
                                    return BuildingID.HORDE_2_UPGR;
                                } else {//upgraded dwelling not presents
                                    return BuildingID.HORDE_2;
                                }
                            }
                        }
                    }
                }
                curPos++;
            }
        }
        //assert(0);
        return BuildingID.NONE; //not found
    }
}