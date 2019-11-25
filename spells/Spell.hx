package lib.spells;

import constants.SpellSchool;
import constants.SpellId;

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
    public var positiveness:Int; //1 if spell is positive for influenced stacks, 0 if it is indifferent, -1 if it's negative

    public var counteredSpells:Array<SpellId>; //spells that are removed when effect of this spell is placed on creature (for bless-curse, haste-slow, and similar pairs)

    public var targetCondition:Dynamic; //custom condition on what spell can affect

    private var defaultProbability:Int;

    private var isRising:Bool;
    private var isDamage:Bool;
    private var isOffensive:Bool;
    private var isSpecial:Bool;

    private var attributes:String; //reference only attributes //todo: remove or include in configuration format, currently unused

    private var targetType:AimType;

    ///graphics related stuff
    private var iconImmune:String;
    private var iconBook:String;
    private var iconEffect:String;
    private var iconScenarioBonus:String;
    private var iconScroll:String;

    ///sound related stuff
    private var castSound:String;

    private var levels:Array<LevelInfo>;

    private var mechanics:ISpellMechanicsFactory;//(!) do not serialize
    private var adventureMechanics:IAdventureSpellMechanics;//(!) do not serialize

    public function new() {
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
}

//struct
class ProjectileInfo {
    ///in radians. Only positive value. Negative angle is handled by vertical flip
    public var minimumAngle:Float;

    ///resource name
    public var resourceName:String;
}

