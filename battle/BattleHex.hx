package lib.battle;

class BattleHex {
    public var hex:Int;
    private static inline var INVALID:Int = -1;

    public function new() {
    }
}

@:enum abstract Dir(Int) from Int to Int {
    public var TOP_LEFT:Int = 0;
    public var TOP_RIGHT:Int = 1;
    public var RIGHT:Int = 2;
    public var BOTTOM_RIGHT:Int = 3;
    public var BOTTOM_LEFT:Int = 4;
    public var LEFT:Int = 5;
    public var NONE:Int = 6;
}