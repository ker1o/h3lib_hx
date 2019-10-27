package lib.herobonus;

@:enum abstract BonusDuration(Int) from Int to Int {
    public var PERMANENT:Int = 1;
    public var ONE_BATTLE:Int = 2; //at the end of battle
    public var ONE_DAY:Int = 4; //at the end of day
    public var ONE_WEEK:Int = 8; //at the end of week (bonus lasts till the end of week, thats NOT 7 days
    public var N_TURNS:Int = 16; //used during battles, after battle bonus is always removed
    public var N_DAYS:Int = 32;
    public var UNTIL_BEING_ATTACKED:Int = 64; //removed after attack and counterattacks are performed
    public var UNTIL_ATTACK:Int = 128; //removed after attack and counterattacks are performed
    public var STACK_GETS_TURN:Int = 256; //removed when stack gets its turn - used for defensive stance
    public var COMMANDER_KILLED:Int = 512;
}
