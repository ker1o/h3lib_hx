package lib.battle;

@:enum abstract ObstacleType(Int) from Int to Int {
    //ABSOLUTE needs an underscore because it's a Win
    public var USUAL:Int = 0;
    public var ABSOLUTE_OBSTACLE:Int = 1;
    public var SPELL_CREATED:Int = 2;
    public var MOAT:Int = 3;
}
