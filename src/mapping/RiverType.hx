package mapping;

@:enum abstract RiverType(Int) from Int to Int {
    public var NO_RIVER:Int = 0;
    public var CLEAR_RIVER:Int = 1;
    public var ICY_RIVER:Int = 2;
    public var MUDDY_RIVER:Int = 3;
    public var LAVA_RIVER:Int = 4;
}
