package pathfinder;

@:enum abstract PathfindingLayer(Int) from Int to Int {
    public var LAND = 0;
    public var SAIL = 1;
    public var WATER = 2;
    public var AIR = 3;
    public var NUM_LAYERS = 4;
    public var WRONG = 5;
    public var AUTO = 6;
}