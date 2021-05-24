package herobonus;

import herobonus.selector.Selector.BonusSelector;
import constants.PrimarySkill;

interface IBonusBearer {
    function getAllBonuses(selector:BonusSelector, limit:BonusSelector, root:BonusSystemNode = null, cachingStr:String = ""):BonusList;
    function getPrimSkillLevel(id:PrimarySkill):Int;
    function getBonuses(selector:BonusSelector, cachingStr:String):BonusList;
    function hasBonus(selector:BonusSelector, cachingStr:String = null):Bool;
    function manaLimit():Int;
}