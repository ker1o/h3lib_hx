package herobonus;

class Bonus {
    public var duration:Int; //uses BonusDuration values
    public var turnsRemain:Int; //used if duration is N_TURNS, N_DAYS or ONE_WEEK

    public var type:BonusType; //uses BonusType values - says to what is this bonus - 1 byte
    public var subtype:Int; //-1 if not applicable - 4 bytes

    public var source:BonusSource;//source type" uses BonusSource values - what gave that bonus
    public var val:Int;
    public var sid:Int; //source id: id of object/artifact/spell
    public var valType:BonusValue;
    public var stacking:String; // bonuses with the same stacking value don't stack (e.g. Angel/Archangel morale bonus)

//    public var additionalInfo:AddInfo; ToDo: abstract on array?
    public var effectRange:LimitEffect; //if not NO_LIMIT, bonus will be omitted by default

    public var limiter:ILimiter;
    public var propagator:IPropagator;
    public var updater:IUpdater;

    public var description:String;

    public function new(
        duration:Int = BonusDuration.PERMANENT,
        type:BonusType = BonusType.NONE,
        src:BonusSource = BonusSource.OTHER,
        val:Int = 0,
        id:Int = 0,
        desc:String = null,
        subtype:Int = -1,
        valType:BonusValue = BonusValue.ADDITIVE_VALUE
    ) {
        turnsRemain = 0;
        effectRange = LimitEffect.NO_LIMIT;
    }

    public static function nDays(hb:Bonus):Bool
    {
        return hb.duration & BonusDuration.N_DAYS > 0;
    }
    public static function nTurns(hb:Bonus):Bool
    {
        return hb.duration & BonusDuration.N_TURNS > 0;
    }
    public static function oneDay(hb:Bonus):Bool
    {
        return hb.duration & BonusDuration.ONE_DAY > 0;
    }
    public static function oneWeek(hb:Bonus):Bool
    {
        return hb.duration & BonusDuration.ONE_WEEK > 0;
    }
    public static function oneBattle(hb:Bonus):Bool
    {
        return hb.duration & BonusDuration.ONE_BATTLE > 0;
    }
    public static function permanent(hb:Bonus):Bool
    {
        return hb.duration & BonusDuration.PERMANENT > 0;
    }
    public static function untilGetsTurn(hb:Bonus):Bool
    {
        return hb.duration & BonusDuration.STACK_GETS_TURN > 0;
    }
    public static function untilAttack(hb:Bonus):Bool
    {
        return hb.duration & BonusDuration.UNTIL_ATTACK > 0;
    }
    public static function untilBeingAttacked(hb:Bonus):Bool
    {
        return hb.duration & BonusDuration.UNTIL_BEING_ATTACKED > 0;
    }
    public static function untilCommanderKilled(hb:Bonus):Bool
    {
        return hb.duration & BonusDuration.COMMANDER_KILLED > 0;
    }

}
