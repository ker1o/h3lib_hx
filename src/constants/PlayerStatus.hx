package constants;

@:enum abstract PlayerStatus(Int) from Int to Int{
    public var WRONG:Int = -1;
    public var INGAME:Int = 0;
    public var LOSER:Int = 1;
    public var WINNER:Int = 2;
}