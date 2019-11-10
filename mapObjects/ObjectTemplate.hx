package lib.mapObjects;

import constants.Obj;
import mapping.TerrainType;

class ObjectTemplate {

    public var id:Obj;
    public var subid:Int;
    /// print priority, objects with higher priority will be print first, below everything else
    public var printPriority:Int;
    /// animation file that should be used to display object
    public var animationFile:String;
    /// map editor only animation file
    public var editorAnimationFile:String;
    /// string ID, equals to def base name for h3m files (lower case, no extension) or specified in mod data
    public var stringID:String;

    private static var VISITABLE_FROM_TOP = [
        Obj.FLOTSAM,
        Obj.SEA_CHEST,
        Obj.SHIPWRECK_SURVIVOR,
        Obj.BUOY,
        Obj.OCEAN_BOTTLE,
        Obj.BOAT,
        Obj.WHIRLPOOL,
        Obj.GARRISON,
        Obj.GARRISON2,
        Obj.SCHOLAR,
        Obj.CAMPFIRE,
        Obj.BORDERGUARD,
        Obj.BORDER_GATE,
        Obj.QUEST_GUARD,
        Obj.CORPSE
    ];

    /// tiles that are covered by this object, uses EBlockMapBits enum as flags
    private var usedTiles: Array<Array<Int>>;
    /// directions from which object can be entered, format same as for moveDir in CGHeroInstance(but 0 - 7)
    private var visitDir: Int;
    /// list of terrains on which this object can be placed
    private var allowedTerrains: Array<TerrainType>;

    public function new() {
        visitDir = 8|16|32|64|128; // all but top
        id = Obj.NO_OBJ;
        subid = 0;
        printPriority = 0;
        stringID = "";
    }

    private function isOnVisitableFromTopList(id:Int, type:Int) {
        if (type == 2 || type == 3 || type == 4 || type == 5) { //creature, hero, artifact, resource
            return true;
        }
        if (VISITABLE_FROM_TOP.indexOf(id) != -1 ) {
            return true;
        }
        return false;
    }
}

@:enum abstract BlockMapBits(Int) from Int to Int {
    public var VISIBLE = 1;
    public var VISITABLE = 2;
    public var BLOCKED = 4;
}