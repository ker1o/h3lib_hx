package mapping.campaign;

@:enum abstract TravelBonusType(Int) from Int to Int {
    public var SPELL:Int;
    public var MONSTER:Int;
    public var BUILDING:Int;
    public var ARTIFACT:Int;
    public var SPELL_SCROLL:Int;
    public var PRIMARY_SKILL:Int;
    public var SECONDARY_SKILL:Int;
    public var RESOURCE:Int;
    public var HEROES_FROM_PREVIOUS_SCENARIO:Int;
    public var HERO:Int;
}