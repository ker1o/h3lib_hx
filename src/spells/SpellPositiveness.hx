package spells;

@:enum abstract SpellPositiveness(Int) from Int to Int {
    public var NEGATIVE:Int = -1;
    public var NEUTRAL:Int = 0;
    public var POSITIVE:Int = 1;
}
