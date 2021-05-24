package herobonus;

import constants.SecondarySkill;
import constants.PrimarySkill;
import herobonus.selector.Selector.BonusSelector;

class BonusBearer implements IBonusBearer {
    private static var anaffectedByMoraleSelector:BonusSelector;
    private var anaffectedByMorale:CheckProxy;
    private static var moraleSelector:BonusSelector;
//    private var moraleValue:TotalsProxy;
    private static var luckSelector:BonusSelector;
//    private var luckValue:TotalsProxy;
    private static var selfMoraleSelector:BonusSelector;
    private var selfMorale:CheckProxy;
    private static var selfLuckSelector:BonusSelector;
    private var selfLuck:CheckProxy;

    public function new() {

    }

    public function getAllBonuses(selector:BonusSelector, limit:BonusSelector, root:BonusSystemNode = null, cachingStr:String = ""):BonusList {
        throw "need to override";
    }

    public function getPrimSkillLevel(id:PrimarySkill) {
        var selectorAllSkills:BonusSelector = BonusSelector.getTypeSelector(BonusType.PRIMARY_SKILL);
        var keyAllSkills = "type_PRIMARY_SKILL";
        var allSkills:BonusList = getBonuses(selectorAllSkills, keyAllSkills);
        var ret = allSkills.valOfBonuses(BonusSelector.getSubTypeSelector(id));
        return ret; //sp=0 works in old saves
    }

    public function getBonuses(selector:BonusSelector, cachingStr:String):BonusList {
        return getAllBonuses(selector, null, null, cachingStr);
    }

    public function hasBonus(selector:BonusSelector, cachingStr:String = null):Bool {
        return getBonuses(selector, cachingStr).length > 0;
    }

    public function manaLimit() {
        return Std.int(getPrimSkillLevel(PrimarySkill.KNOWLEDGE)
            * (100.0 + valOfBonuses(BonusType.SECONDARY_SKILL_PREMY, SecondarySkill.INTELLIGENCE))
            / 10.0);
    }

    public function valOfBonuses(type:BonusType, subtype:Int) {
        var fmt = ('type_${type}_${subtype}');

        var s = BonusSelector.getTypeSelector(type);
        if (subtype != -1) {
            s = s.and(BonusSelector.getSubTypeSelector(subtype));
        }

        return valueOfBonuses(s, fmt);
    }

    function valueOfBonuses(selector:BonusSelector, cachingStr:String) {
        var limit:BonusSelector = null;
        var hlp = getAllBonuses(selector, limit, null, cachingStr);
        return hlp.totalValue();
    }
}