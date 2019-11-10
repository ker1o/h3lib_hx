package lib.mapObjects.rewardable;

import lib.mapObjects.rewardable.RewardableObject.SelectMode;
import lib.mapObjects.rewardable.RewardableObject.VisitMode;

class GBonusingObject extends RewardableObject { //objects giving bonuses to luck/morale/movement

    public function new() {
        super();

        visitMode = VisitMode.VISIT_BONUS;
        selectMode = SelectMode.SELECT_FIRST;
    }
}
