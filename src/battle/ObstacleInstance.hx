package battle;

import battle.ObstacleType;

class ObstacleInstance {
    public var pos:BattleHex; //position on battlefield, typically left bottom corner
    public var obstacleType:ObstacleType; //if true, then position is meaningless
    public var uniqueID:Int;
    public var ID:Int; //ID of obstacle (defines type of it)

    public function new() {
        obstacleType = ObstacleType.USUAL;
        uniqueID = -1;
        ID = -1;
    }
}
