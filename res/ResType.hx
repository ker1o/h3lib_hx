package lib.res;

@:enum abstract ResType(Int) from Int to Int {
    public var WOOD:Int = 0;
    public var MERCURY:Int = 1;
    public var ORE:Int = 2;
    public var SULFUR:Int = 3;
    public var CRYSTAL:Int = 4;
    public var GEMS:Int = 5;
    public var GOLD:Int = 6;
    public var MITHRIL:Int = 7;

    public var WOOD_AND_ORE:Int = 127;  // special case for town bonus resource
    public var INVALID:Int = -1;
}
