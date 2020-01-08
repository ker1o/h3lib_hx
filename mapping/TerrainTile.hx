package lib.mapping;

import lib.mapObjects.GObjectInstance;

class TerrainTile {

    public var terType:TerrainType;
    public var terView:Int;
    public var riverType:RiverType;
    public var riverDir:Int;
    public var roadType:RoadType;
    public var roadDir:Int;

    public var extTileFlags:Int;
    public var visitable:Bool;
    public var blocked:Bool;

    public var visitableObjects:Array<GObjectInstance>;
    public var blockingObjects:Array<GObjectInstance>;

    public function new() {
        terType = TerrainType.BORDER;
        terView = 0;
        riverType = RiverType.NO_RIVER;
        riverDir = 0;
        roadType = RoadType.NO_ROAD;
        roadDir = 0;
        extTileFlags = 0;
        visitable = false;
        blocked = false;

        visitableObjects = [];
        blockingObjects = [];
    }

    public inline function isWater():Bool {
        return terType == TerrainType.WATER;
    }

    public function entrableTerrainTile(from:TerrainTile = null):Bool {
        return entrableTerrain(from != null ? from.terType != TerrainType.WATER : true, from != null ? from.terType == TerrainType.WATER : true);
    }

    public function entrableTerrain(allowLand:Bool, allowSea:Bool):Bool {
        return terType != TerrainType.ROCK && ((allowSea && terType == TerrainType.WATER) || (allowLand && terType != TerrainType.WATER));
    }

}
