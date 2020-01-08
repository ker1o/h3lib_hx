package mapping;

@:enum abstract TerrainGroup(Int) from Int to Int {
    public var NORMAL:Int = 0;
    public var DIRT:Int = 1;
    public var SAND:Int = 2;
    public var WATER:Int = 3;
    public var ROCK:Int = 4;
}