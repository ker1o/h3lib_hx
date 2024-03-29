package mapObjects;

import constants.GameConstants;
import utils.Array2D;
import filesystem.FileCache;
import utils.Int3;
import filesystem.BinaryReader;
import constants.Obj;
import mapping.TerrainType;

using StringTools;
using Reflect;

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
    private var usedTiles:Array2D<BlockMapBits>;
    /// directions from which object can be entered, format same as for moveDir in CGHeroInstance(but 0 - 7)
    private var visitDir:Int;
    /// list of terrains on which this object can be placed
    private var allowedTerrains:Array<TerrainType>;

    public function new() {
        visitDir = 8|16|32|64|128; // all but top
        id = Obj.NO_OBJ;
        subid = 0;
        printPriority = 0;
        stringID = "";
        editorAnimationFile = "";

        usedTiles = new Array2D<BlockMapBits>();
        allowedTerrains = [];
    }

    public function readTxt(s:String):Void {
        var strings:Array<String> = s.split(" ");

        animationFile = strings[0];
        stringID = strings[0];

        var blockStr = strings[1]; //block map, 0 = blocked, 1 = unblocked
        var visitStr = strings[2]; //visit map, 1 = visitable, 0 = not visitable

        setSize(8, 6);
        for (i in 0...6) { // 6 rows
            for (j in 0...8) { // 8 columns
                var tile = VISIBLE; // assume that all tiles are visible
                if (blockStr.charAt(i*8 + j) == '0') {
                    tile = tile | BLOCKED;
                }

                if (visitStr.charAt(i*8 + j) == '1') {
                    tile = tile | VISITABLE;
                }
                usedTiles.set(i, j, tile);
            }
        }

        // strings[3] most likely - terrains on which this object can be placed in editor.
        // e.g. Whirpool can be placed manually only on water while mines can be placed everywhere despite terrain-specific gfx
        // so these two fields can be interpreted as "strong affinity" and "weak affinity" towards terrains
        var terrStr:String = strings[4]; // allowed terrains, 1 = object can be placed on this terrain

        //assert(terrStr.size() == 9); // all terrains but rock
        for (i in 0...9) {
            if (terrStr.charAt(8-i) == '1')
                allowedTerrains.push((i:TerrainType));
        }

        id    = (Std.parseInt(strings[5]):Obj);
        subid = Std.parseInt(strings[6]);
        var type:Int  = Std.parseInt(strings[7]);
        printPriority = Std.parseInt(strings[8]) * 100; // to have some space in future

        if (isOnVisitableFromTopList(id, type))
            visitDir = 0xff;
        else
            visitDir = (8|16|32|64|128);

        readMsk();
    }

    public function setSize(width:UInt, height:UInt) {
        usedTiles.reset(width, height);
    }

    public function readMsk() {
        var mskFileName = animationFile.substr(0, animationFile.length - 3).toLowerCase() + "msk";
//        var resID = new ResourceID("SPRITES/" + animationFile, ResType.MASK);

        if (FileCache.instance.existsSpriteResource(mskFileName)) {
//            trace('Reading $mskFileName');
            var msk = FileCache.instance.getCahedFile(mskFileName);
            setSize(msk.get(0), msk.get(1));
        } else {//maximum possible size of H3 object //TODO: remove hardcode and move this data into modding system
            trace('Can\'t find $mskFileName');
            setSize(8, 6);
        }
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

    public function readMap(reader:BinaryReader) {
        animationFile = reader.readString();

        setSize(8, 6);
        var blockMaskLength = 6;
        var visitMaskLength = 6;
        var blockMask:Array<Int> = [];
        var visitMask:Array<Int> = [];
        for (i in 0...blockMaskLength) {
            blockMask[i] = reader.readUInt8();
        }
        for (i in 0...visitMaskLength) {
            visitMask[i] = reader.readUInt8();
        }

        for (i in 0...6) {// 6 rows
            for (j in 0...8) { // 8 columns
                var tile = usedTiles.get(5 - i, 7 - j);
                tile = tile | VISIBLE; // assume that all tiles are visible
                if (((blockMask[i] >> j) & 1 ) == 0) {
                    tile = tile | BLOCKED;
                }
                if (((visitMask[i] >> j) & 1 ) != 0) {
                    tile = tile | VISITABLE;
                }
                usedTiles.set(5 - i, 7 - j, tile);
            }
        }

        reader.readUInt16();
        var terrMask = reader.readUInt16();
        for (i in 0...9) {
            if (((terrMask >> i) & 1 ) != 0) {
                allowedTerrains.push((i:TerrainType));
            }
        }

        id = (reader.readUInt32():Obj);
        subid = reader.readUInt32();
        var type:Int = reader.readUInt8();
        printPriority = reader.readUInt8() * 100; // to have some space in future

        if (isOnVisitableFromTopList(id, type)) {
            visitDir = 0xff;
        } else {
            visitDir = (8|16|32|64|128);
        }

        reader.skip(16);
        readMsk();

        afterLoadFixup();
    }

    private function afterLoadFixup() {
        if (id == Obj.EVENT) {
            setSize(1,1);
            usedTiles.set(0, 0, VISITABLE);
            visitDir = 0xFF;
        }
        animationFile.replace("\\", "/");
        editorAnimationFile.replace("\\", "/");
    }

    public inline function getHeight() {
        return usedTiles.rows;
    }

    public inline function getWidth() {
        return usedTiles.cols;
    }

    public function isWithin(x:Int, y:Int):Bool {
        if (x < 0 || y < 0) return false;
        if (x >= getWidth() || y >= getHeight()) {
            return false;
        }
        return true;
    }

    public function isVisitableAt(x:Int, y:Int):Bool {
        if (isWithin(x, y)) {
            return usedTiles.get(y, x) & VISITABLE > 0;
        }
        return false;
    }

    public function isBlockedAt(x:Int, y:Int):Bool {
        if (isWithin(x, y)) {
            return usedTiles.get(y, x) & BLOCKED > 0;
        }
        return false;
    }

    public function getVisitableOffset():Int3 {
        for (y in 0...getHeight()) {
            for (x in 0...getWidth()) {
                if (isVisitableAt(x, y))
                    return new Int3(x, y, 0);
            }
        }

        //logGlobal->warn("Warning: getVisitableOffset called on non-visitable obj!");
        return new Int3(0,0,0);
    }

    public function isVisitableFrom(x:Int, y:Int) {
        // visitDir uses format
        // 1 2 3
        // 8   4
        // 7 6 5
        var dirMap = [ visitDir &   1, visitDir &   2, visitDir &   4 ,
                       visitDir & 128,        1      , visitDir &   8 ,
                       visitDir &  64, visitDir &  32, visitDir &  16 ];

        // map input values to range 0..2
        var dx:Int = x < 0 ? 0 : x == 0 ? 1 : 2;
        var dy:Int = y < 0 ? 0 : y == 0 ? 1 : 2;

        return dirMap[dy * 3 + dx] != 0;
    }

    public function isVisitable() {
        for (tile in usedTiles.data)
            if (tile & VISITABLE > 0)
                return true;
        return false;
    }

    public function isVisibleAt(x:Int, y:Int) {
        if (isWithin(x, y))
            return usedTiles.get(y, x) & VISIBLE > 0;
        return false;
    }

    public function canBePlacedAt(terrain:TerrainType) {
        return allowedTerrains.indexOf(terrain) != -1;
    }

    public function readJson(node:Dynamic, withTerrain:Bool = false) {
        animationFile = node.hasField("animation") ? node.field("animation") : "";
        editorAnimationFile = node.hasField("editorAnimation") ? node.field("editorAnimation") : "";

        var visitDirs:Array<Dynamic> = node.field("visitableFrom");
        if (visitDirs!= null && visitDirs.length > 0) {
            if (visitDirs[0].charAt(0) == '+') visitDir |= 1;
            if (visitDirs[0].charAt(1) == '+') visitDir |= 2;
            if (visitDirs[0].charAt(2) == '+') visitDir |= 4;
            if (visitDirs[1].charAt(2) == '+') visitDir |= 8;
            if (visitDirs[2].charAt(2) == '+') visitDir |= 16;
            if (visitDirs[2].charAt(1) == '+') visitDir |= 32;
            if (visitDirs[2].charAt(0) == '+') visitDir |= 64;
            if (visitDirs[1].charAt(0) == '+') visitDir |= 128;
        } else {
            visitDir = 0x00;
        }

        if (withTerrain && node.hasField("allowedTerrains")) {
            var allowedTerrainsObj:Array<Dynamic> = node.field("allowedTerrains");
            for (entry in allowedTerrainsObj) {
                allowedTerrains.push(StringConstants.TERRAIN_NAMES.indexOf(entry));
            }
        } else {
            for (i in 0...GameConstants.TERRAIN_TYPES) {
                allowedTerrains.push((i:TerrainType));
            }

            allowedTerrains.remove(TerrainType.ROCK);
        }

        if (withTerrain && allowedTerrains.length == 0) {
            trace("Loaded template without allowed terrains!");
        }

        var charToTile = function(ch:String) {
            return switch (ch) {
                case ' ' : 0;
                case '0' : 0;
                case 'V' : VISIBLE;
                case 'B' : VISIBLE | BLOCKED;
                case 'H' : BLOCKED;
                case 'A' : VISIBLE | BLOCKED | VISITABLE;
                case 'T' : BLOCKED | VISITABLE;
                default:
                    throw 'Unrecognized char $ch in template mask';
            }
        };

        var mask:Array<Dynamic> = node.field("mask");
        if (mask == null) {
            mask = [];
        }

        var height = mask.length;
        var width  = 0;
        for (line in mask) {
            width = cast Math.max(width, line.length);
        }

        setSize(width, height);

        for (i in 0...mask.length) {
            var line = mask[i];
            for (j in 0...line.length) {
                usedTiles.set(mask.length - 1 - i, line.length - 1 - j, charToTile(line[j]));
            }
        }

        printPriority = node.field("zIndex");

        afterLoadFixup();
    }
}

@:enum abstract BlockMapBits(Int) from Int to Int {
    public var VISIBLE = 1;
    public var VISITABLE = 2;
    public var BLOCKED = 4;
}