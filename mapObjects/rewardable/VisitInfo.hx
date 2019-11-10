package lib.mapObjects.rewardable;

import lib.netpacks.MetaString;

class VisitInfo {
    public var limiter:RewardLimiter;
    public var reward:RewardInfo;

    /// Message that will be displayed on granting of this reward, if not empty
    public var message:MetaString;

    /// Chance for this reward to be selected in case of random choice
    public var selectChance:Int;

    /// How many times this reward has been granted since last reset
    public var numOfGrants:Int;

    public function new() {
    }
}
