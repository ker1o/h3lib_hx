package lib.mapObjects.rewardable;

/// Limiters of rewards. Rewards will be granted to hero only if he satisfies requirements
/// Note: for this is only a test - it won't remove anything from hero (e.g. artifacts or creatures)
/// NOTE: in future should (partially) replace seer hut/quest guard quests checks
import constants.ArtifactId;
import constants.SecondarySkill;
import lib.creature.Creature.Resources;
import lib.creature.StackBasicDescriptor;

class RewardLimiter {
    /// how many times this reward can be granted, 0 for unlimited
    public var numOfGrants:Int;

    /// day of week, unused if 0, 1-7 will test for current day of week
    public var dayOfWeek:Int;

    /// level that hero needs to have
    public var minLevel:Int;

    /// resources player needs to have in order to trigger reward
    public var resources:Resources;

    /// skills hero needs to have
    public var primary:Array<Int>;
    public var secondary:Map<SecondarySkill, Int>;

    /// artifacts that hero needs to have (equipped or in backpack) to trigger this
    /// Note: does not checks for multiple copies of the same arts
    public var artifacts:Array<ArtifactId>;

    /// creatures that hero needs to have
    public var creatures:Array<StackBasicDescriptor>;
    
    public function new() {
        numOfGrants = 0;
        dayOfWeek = 0;
        minLevel = 0;
        primary = [0, 0, 0, 0];
    }
}
