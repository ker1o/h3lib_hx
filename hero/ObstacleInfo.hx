package lib.hero;

import constants.BFieldType;
import mapping.TerrainType;

class ObstacleInfo {

    public var ID:Int;
    public var defName:String;
    public var allowedTerrains:Array<TerrainType>;
    public var allowedSpecialBfields:Array<BFieldType>;

    public var isAbsoluteObstacle:Bool; //there may only one such obstacle in battle and its position is always the same
    public var width:Int; //how much space to the right and up is needed to place obstacle (affects only placement algorithm)
    public var height:Int;
    public var blockedTiles:Array<Int>; //offsets relative to obstacle position (that is its left bottom corner)

    public function new() {

    }
}
