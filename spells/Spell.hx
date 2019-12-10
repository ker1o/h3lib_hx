package lib.spells;

import lib.mod.ModHandler;
import lib.herobonus.BonusType;
import constants.SpellSchool;
import constants.SpellId;

using Reflect;

class Spell implements ISpell {
    public var animationInfo:AnimationInfo;

    public var id:SpellId;
    public var identifier:String;
    public var name:String;

    public var level:Int;

    public var school:Map<SpellSchool, Bool>;

    public var power:Int; //spell's power

    public var probabilities:Map<UInt, Int>; //% chance to gain for castles

    public var combatSpell:Bool; //is this spell combat (true) or adventure (false)
    public var creatureAbility:Bool; //if true, only creatures can use this spell
    public var positiveness:SpellPositiveness; //1 if spell is positive for influenced stacks, 0 if it is indifferent, -1 if it's negative

    public var counteredSpells:Array<SpellId>; //spells that are removed when effect of this spell is placed on creature (for bless-curse, haste-slow, and similar pairs)

    public var targetCondition:Dynamic; //custom condition on what spell can affect

    public var defaultProbability:Int;

    public var isRising:Bool;
    public var isDamage:Bool;
    public var isOffensive:Bool;
    public var isSpecial:Bool;

    public var attributes:String; //reference only attributes //todo: remove or include in configuration format, currently unused

    public var targetType:AimType;

    ///graphics related stuff
    public var iconImmune:String;
    public var iconBook:String;
    public var iconEffect:String;
    public var iconScenarioBonus:String;
    public var iconScroll:String;

    ///sound related stuff
    public var castSound:String;

    public var levels:Array<LevelInfo>;

    public var mechanics:ISpellMechanicsFactory;//(!) do not serialize
    public var adventureMechanics:IAdventureSpellMechanics;//(!) do not serialize

    public function new() {
        animationInfo = new AnimationInfo();
        school = new Map<SpellSchool, Bool>();
        probabilities = new Map<UInt, Int>();
        counteredSpells = [];
        levels = [];
    }

    public inline function getTargetType():AimType {
        return targetType;
    }

    public inline function isSpecialSpell() {
        return isSpecial;
    }

    public inline function isCreatureAbility() {
        return creatureAbility;
    }

    public inline function isOffensiveSpell() {
        return isOffensive;
    }

    public function setIsOffensive(value:Bool) {
        isOffensive = value;

        if (value) {
            positiveness = SpellPositiveness.NEGATIVE;
            isDamage = true;
        }
    }

    public function setIsRising(value:Bool) {
        isRising = value;

        if (value) {
            positiveness = SpellPositiveness.POSITIVE;
        }
    }

    public function convertTargetCondition(immunity:Array<BonusType>, absImmunity:Array<BonusType>, limit:Array<BonusType>, absLimit:Array<BonusType>):Dynamic {
        var CONDITION_NORMAL = "normal";
        var CONDITION_ABSOLUTE = "absolute";

        var res:Dynamic = {};

        function convertVector(targetName:String, source:Array<BonusType>, value:String) {
            for(bonusType in source) {
                var fullId = ModHandler.makeFullIdentifier("", "bonus", bonusType.toString());
                res.setField(targetName, {fullId: value});
            }
        }

        var convertSection = function(targetName:String, normal:Array<BonusType>, absolute:Array<BonusType>) {
            convertVector(targetName, normal, CONDITION_NORMAL);
            convertVector(targetName, absolute, CONDITION_ABSOLUTE);
        };

        convertSection("allOf", limit, absLimit);
        convertSection("noneOf", immunity, absImmunity);

        return res;
    }
}

//struct
class ProjectileInfo {
    ///in radians. Only positive value. Negative angle is handled by vertical flip
    public var minimumAngle:Float;

    ///resource name
    public var resourceName:String;

    public function new() {}
}

