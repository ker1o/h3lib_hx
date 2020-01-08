package lib.mapping;

@:enum abstract RoadType(Int) from Int to Int {
    public var NO_ROAD:Int = 0;
    public var DIRT_ROAD:Int = 1;
    public var GRAVEL_ROAD:Int = 2;
    public var COBBLESTONE_ROAD:Int = 3;
}
