package lib.mapObjects.rewardable;

/// Reward that can be granted to a hero
/// NOTE: eventually should replace seer hut rewards and events/pandoras
import constants.ArtifactId;
import constants.SecondarySkill;
import constants.SpellId;
import lib.creature.Creature.Resources;
import lib.creature.StackBasicDescriptor;
import lib.herobonus.Bonus;
import lib.netpacks.Component;

class RewardInfo {
    /// resources that will be given to player
    public var resources:Resources;

    /// received experience
    public var gainedExp:UInt;
    /// received levels (converted into XP during grant)
    public var gainedLevels:UInt;

    /// mana given to/taken from hero, fixed value
    public var manaDiff:Int;
    /// fixed value, in form of percentage from max
    public var manaPercentage:Int;

    /// movement points, only for current day. Bonuses should be used to grant MP on any other day
    public var movePoints:Int;
    /// fixed value, in form of percentage from max
    public var movePercentage:Int;

    /// list of bonuses, e.g. morale/luck
    public var bonuses:Array<Bonus>;

    /// skills that hero may receive or lose
    public var primary:Array<Int>;
    public var secondary:Map<SecondarySkill, Int>;

    /// objects that hero may receive
    public var artifacts:Array<ArtifactId>;
    public var spells:Array<SpellId>;
    public var creatures:Array<StackBasicDescriptor>;

    /// list of components that will be added to reward description. First entry in list will override displayed component
    public var extraComponents:Array<Component>;

    /// if set to true, object will be removed after granting reward
    public var removeObject:Bool;

    public function new() {
    }
}
