package lib.mapping;

@:enum abstract LossConditionType(Int) from Int to Int {
    public var LOSSCASTLE:Int = 0;
    public var LOSSHERO:Int = 1;
    public var TIMEEXPIRES:Int = 2;
    public var LOSSSTANDARD = 255;
}
