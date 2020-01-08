package constants;

@:enum abstract AiTactic(Int) from Int to Int {
    public var NONE:Int = -1;
    public var RANDOM:Int = 0;
    public var WARRIOR:Int = 1;
    public var BUILDER:Int = 2;
    public var EXPLORER:Int = 3;
}
