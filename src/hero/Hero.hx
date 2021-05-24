package hero;

import herobonus.BonusList;
import constants.SpellId;
import constants.SecondarySkill;
import constants.id.HeroTypeId;

class Hero {

    public var identifier:String;
    public var ID:HeroTypeId;
    public var imageIndex:Int;

    public var initialArmy:Array<InitialArmyStack>;

    public var heroClass:HeroClass;
    public var secSkillsInit:Array<{skill:SecondarySkill, level:Int}>; //initial secondary skills; first - ID of skill, second - level of skill (1 - basic, 2 - adv., 3 - expert)
    public var specDeprecated:Array<SpecialtyInfo>;
    public var specialtyDeprecated:Array<SpecialtyBonus>;
    public var specialty:BonusList;
    public var spells:Array<SpellId>; //originally set
    public var haveSpellBook:Bool;
    public var special:Bool; // hero is special and won't be placed in game (unless preset on map), e.g. campaign heroes
    public var sex:Int; // default sex: 0=male, 1=female

    /// Localized texts
    public var name:String; //name of hero
    public var biography:String;
    public var specName:String;
    public var specDescr:String;
    public var specTooltip:String;

    /// Graphics
    public var iconSpecSmall:String;
    public var iconSpecLarge:String;
    public var portraitSmall:String;
    public var portraitLarge:String;
    public var battleImage:String;

    public function new() {
    }

    public function copy() {
        //ToDo
    }
}
