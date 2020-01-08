package battle;

import constants.BFieldType;
import mapObjects.town.GTownInstance;
import mapping.TerrainType;
import utils.Int3;

class BattleInfo {
    public var attacker:SideInBattle;
    public var defender:SideInBattle;
    public var round:Int;
    public var activeStack:Int;
    public var town:GTownInstance; //used during town siege, nullptr if this is not a siege (note that fortless town IS also a siege)
    public var tile:Int3; //for background and bonuses
    public var stacks:Array<Stack>;
    public var obstacles:Array<ObstacleInstance>;
    public var si:SiegeInfo;

    public var battlefieldType:BFieldType; //like !!BA:B
    public var terrainType:TerrainType; //used for some stack nativity checks (not the bonus limiters though that have their own copy)

    public var tacticsSide:UInt; //which side is requested to play tactics phase
    public var tacticDistance:UInt; //how many hexes we can go forward (1 = only hexes adjacent to margin line)

    public function new() {
    }
}
