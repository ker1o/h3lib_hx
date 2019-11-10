package lib.herobonus;

@:enum abstract BonusSystemNodeType(Int) from Int to Int  {
    public var UNKNOWN:Int = 0;
    public var STACK_INSTANCE:Int = 1;
    public var STACK_BATTLE:Int = 2;
    public var SPECIALTY:Int = 3;
    public var ARTIFACT:Int = 4;
    public var CREATURE:Int = 5;
    public var ARTIFACT_INSTANCE:Int = 6;
    public var HERO:Int = 7;
    public var PLAYER:Int = 8;
    public var TEAM:Int = 9;
    public var TOWN_AND_VISITOR:Int = 10;
    public var BATTLE:Int = 11;
    public var COMMANDER:Int = 12;
    public var GLOBAL_EFFECTS = 13;
}
