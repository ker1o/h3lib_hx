package mapObjects.rewardable;

import mapObjects.rewardable.RewardableObject.VisitMode;

// objects visitable once per week
class GVisitableOPW extends RewardableObject {

    public function new() {
        super();

        visitMode = VisitMode.VISIT_ONCE;
        resetDuration = 7;
    }
}
