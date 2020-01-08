package netpacks;

@:enum abstract ComponentType(Int) from Int to Int {
    public var PRIM_SKILL:Int = 0;
    public var SEC_SKILL:Int = 1;
    public var RESOURCE:Int = 2;
    public var CREATURE:Int = 3;
    public var ARTIFACT:Int = 4;
    public var EXPERIENCE:Int = 5;
    public var SPELL:Int = 6;
    public var MORALE:Int = 7;
    public var LUCK:Int = 8;
    public var BUILDING:Int = 9;
    public var HERO_PORTRAIT:Int = 10;
    public var FLAG:Int = 11;
}
