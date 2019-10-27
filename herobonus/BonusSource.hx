package lib.herobonus;

@:enum abstract BonusSource(Int) from Int to Int {
    public var ARTIFACT:Int = 1;
    public var ARTIFACT_INSTANCE:Int = 2;
    public var OBJECT:Int = 3;
    public var CREATURE_ABILITY:Int = 4;
    public var TERRAIN_NATIVE:Int = 5;
    public var TERRAIN_OVERLAY:Int = 6;
    public var SPELL_EFFECT:Int = 7;
    public var TOWN_STRUCTURE:Int = 8;
    public var HERO_BASE_SKILL:Int = 9;
    public var SECONDARY_SKILL:Int = 10;
    public var HERO_SPECIAL:Int = 11;
    public var ARMY:Int = 12;
    public var CAMPAIGN_BONUS:Int = 13;
    public var SPECIAL_WEEK:Int = 14;
    public var STACK_EXPERIENCE:Int = 15;
    public var COMMANDER:Int = 16; //TODO: consider using simply STACK_INSTANCE
    public var OTHER:Int = 17; //used for defensive stance and default value of spell level limit

}
