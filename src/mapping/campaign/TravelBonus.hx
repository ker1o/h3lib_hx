package mapping.campaign;

class TravelBonus {
    public var type:TravelBonusType; //uses EBonusType
    public var info1:Int;
    public var info2:Int;
    public var info3:Int; //purpose depends on type

    public function new() {

    }

    public function isBonusForHero() {
        return type == TravelBonusType.SPELL
            || type == TravelBonusType.MONSTER
            || type == TravelBonusType.ARTIFACT
            || type == TravelBonusType.SPELL_SCROLL
            || type == TravelBonusType.PRIMARY_SKILL
            || type == TravelBonusType.SECONDARY_SKILL;
    }
}