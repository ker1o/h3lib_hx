package mapping;

@:enum abstract TerrainType(Int) from Int to Int {
    public var WRONG:Int = -2;
    public var BORDER:Int = -1;
    public var DIRT:Int = 0;
    public var SAND:Int = 1;
    public var GRASS:Int = 2;
    public var SNOW:Int = 3;
    public var SWAMP:Int = 4;
    public var ROUGH:Int = 5;
    public var SUBTERRANEAN:Int = 6;
    public var LAVA:Int = 7;
    public var WATER:Int = 8;
    public var ROCK:Int = 9;
}
