package lib.mapObjects.misc;

@:enum abstract Passability(Int) from Int to Int {
    public var UNKNOWN:Int = 0;
    public var IMPASSABLE:Int = 1;
    public var PASSABLE:Int = 2;
}
