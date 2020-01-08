package spells;

@:enum abstract AimType(Int) from Int to Int {
    public var NO_TARGET:Int = 0;
    public var CREATURE:Int = 1;
    public var OBSTACLE:Int = 2;
    public var LOCATION:Int = 3;
}
