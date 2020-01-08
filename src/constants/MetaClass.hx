package constants;

@:enum abstract MetaClass(Int) from Int to Int {
    public var INVALID:Int = 0;
    public var ARTIFACT:Int = 1;
    public var CREATURE:Int = 2;
    public var FACTION:Int = 3;
    public var EXPERIENCE:Int = 4;
    public var HERO:Int = 5;
    public var HEROCLASS:Int = 6;
    public var LUCK:Int = 7;
    public var MANA:Int = 8;
    public var MORALE:Int = 9;
    public var MOVEMENT:Int = 10;
    public var OBJECT:Int = 11;
    public var PRIMARY_SKILL:Int = 12;
    public var SECONDARY_SKILL:Int = 13;
    public var SPELL:Int = 14;
    public var RESOURC:Int = 15;
}
