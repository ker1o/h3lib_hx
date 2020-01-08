package lib.spells;

import lib.constants.SecondarySkill;
import lib.herobonus.BonusType;
import lib.constants.SpellSchool;

typedef SchoolInfo = {
    id:SpellSchool, //backlink
    damagePremyBonus:BonusType,
    immunityBonus:BonusType,
    jsonName:String,
    skill:SecondarySkill,
    knoledgeBonus:BonusType
};

class SpellConfig {
    public static var LEVEL_NAMES = ["none", "basic", "advanced", "expert"];
    public static var SCHOOL_ORDER:Array<SpellSchool> = [SpellSchool.AIR, SpellSchool.FIRE, SpellSchool.EARTH, SpellSchool.WATER];

    public static var SCHOOL:Array<SchoolInfo> = [
        {
            id: SpellSchool.AIR,
            damagePremyBonus: BonusType.AIR_SPELL_DMG_PREMY,
            immunityBonus: BonusType.AIR_IMMUNITY,
            jsonName: "air",
            skill: SecondarySkill.AIR_MAGIC,
            knoledgeBonus: BonusType.AIR_SPELLS
        },
        {
            id: SpellSchool.FIRE,
            damagePremyBonus: BonusType.FIRE_SPELL_DMG_PREMY,
            immunityBonus: BonusType.FIRE_IMMUNITY,
            jsonName: "fire",
            skill: SecondarySkill.FIRE_MAGIC,
            knoledgeBonus: BonusType.FIRE_SPELLS
        },
        {
            id: SpellSchool.WATER,
            damagePremyBonus: BonusType.WATER_SPELL_DMG_PREMY,
            immunityBonus: BonusType.WATER_IMMUNITY,
            jsonName: "water",
            skill: SecondarySkill.WATER_MAGIC,
            knoledgeBonus: BonusType.WATER_SPELLS
        },
        {
            id: SpellSchool.EARTH,
            damagePremyBonus: BonusType.EARTH_SPELL_DMG_PREMY,
            immunityBonus: BonusType.EARTH_IMMUNITY,
            jsonName: "earth",
            skill: SecondarySkill.EARTH_MAGIC,
            knoledgeBonus: BonusType.EARTH_SPELLS
        }
    ];

}
