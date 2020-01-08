package lib.constants;

@:enum abstract SecSkillLevel(Int) from Int to Int {
    public var NONE:Int = 0;
    public var BASIC:Int = 1;
    public var ADVANCED:Int = 2;
    public var EXPERT:Int = 3;
    public var LEVELS_SIZE:Int = 4;
}
