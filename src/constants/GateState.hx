package constants;

@:enum abstract GateState(Int) from Int to Int {
    public var NONE:Int = 0;
    public var CLOSED:Int = 1;
    public var BLOCKED:Int = 2; //dead or alive stack blocking from outside
    public var OPENED:Int = 3;
    public var DESTROYED:Int = 4;
}
