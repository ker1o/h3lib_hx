package lib.herobonus;

@:enum abstract LimitEffect(Int) from Int to Int {
    public var NO_LIMIT:Int = 0;
    public var ONLY_DISTANCE_FIGHT:Int = 1;
    public var ONLY_MELEE_FIGHT:Int = 2; //used to mark bonuses for attack/defense primary skills from spells like Precision (distance only)
    public var ONLY_ENEMY_ARMY:Int = 3;
}
