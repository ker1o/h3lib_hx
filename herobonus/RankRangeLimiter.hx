package lib.herobonus;

import lib.creature.StackInstance;

class RankRangeLimiter implements ILimiter {
    public var minRank:Int;
    public var maxRank:Int;

    public function new(min:Int = 0, max:Int = 255) {
        minRank = min;
        maxRank = max;
    }

    public function limit(context:BonusLimitationContext):Bool {
        var csi:StackInstance = HeroBonus.retrieveStackInstance(context.node);
        if(csi != null) {
            if (csi.getNodeType() == BonusSystemNodeType.COMMANDER) {//no stack exp bonuses for commander creatures
                return true;
            }
            return csi.getExpRank() < minRank || csi.getExpRank() > maxRank;
        }
        return true;
    }
}
