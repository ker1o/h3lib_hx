package lib.constants;

@:enum abstract PrimarySkill(Int) from Int to Int {
    public var ATTACK:Int = 0;
    public var DEFENSE:Int = 1;
    public var SPELL_POWER:Int = 2;
    public var KNOWLEDGE:Int = 3;
    public var EXPERIENCE:Int = 4; //for some reason changePrimSkill uses it
}
