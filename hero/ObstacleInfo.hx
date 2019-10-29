package lib.hero;

import constants.BFieldType;
import mapping.TerrainType;

class ObstacleInfo {

    var ID:Int;
    var defName:String;
    var allowedTerrains:Array<TerrainType>;
    var allowedSpecialBfields:Array<BFieldType>;

    var isAbsoluteObstacle:Int; //there may only one such obstacle in battle and its position is always the same
    var width:Int; //how much space to the right and up is needed to place obstacle (affects only placement algorithm)
    var height:Int;
    var blockedTiles:Array<Int>; //offsets relative to obstacle position (that is its left bottom corner)

    public function new() {

    }
}
