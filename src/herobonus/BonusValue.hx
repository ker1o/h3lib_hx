package herobonus;

@:enum abstract BonusValue(Int) from Int to Int {
    public var ADDITIVE_VALUE:Int = 1; //
    public var BASE_NUMBER:Int = 2; //
    public var PERCENT_TO_ALL:Int = 3; //
    public var PERCENT_TO_BASE:Int = 4; //
    public var INDEPENDENT_MAX:Int = 5; // used for SPELL bonus
    public var INDEPENDENT_MIN:Int = 6; // used for SECONDARY_SKILL_PREMY bonus
}
