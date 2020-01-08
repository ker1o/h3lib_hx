package spells;

@:enum abstract Mode(Int) from Int to Int {
    //ACTIVE, //todo: use
    public var HERO:Int = 0; //deprecated
    public var MAGIC_MIRROR:Int = 1;
    public var CREATURE_ACTIVE:Int = 2; //deprecated
    public var ENCHANTER:Int = 3;
    public var SPELL_LIKE_ATTACK:Int = 4;
    public var PASSIVE:Int = 5; //f.e. opening battle spells
}
