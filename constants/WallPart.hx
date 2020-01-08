package lib.constants;

@:enum abstract WallPart(Int) from Int to Int {
    public var INDESTRUCTIBLE_PART_OF_GATE = -3;
    public var INDESTRUCTIBLE_PART = -2;
    public var INVALID = -1;
    public var KEEP = 0;
    public var BOTTOM_TOWER:Int = 1;
    public var BOTTOM_WALL:Int = 2;
    public var BELOW_GATE:Int = 3;
    public var OVER_GATE:Int = 4;
    public var UPPER_WALL:Int = 5;
    public var UPPER_TOWER:Int = 6;
    public var GATE:Int = 7;
    public var PARTS_COUNT:Int = 8; /* This constant SHOULD always stay as the last item in the enum. */
}
