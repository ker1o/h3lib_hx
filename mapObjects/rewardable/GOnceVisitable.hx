package lib.mapObjects.rewardable;

// wagon, corpse, lean to, warriors tomb
import lib.mapObjects.rewardable.RewardableObject.SelectMode;
import lib.mapObjects.rewardable.RewardableObject.VisitMode;

class GOnceVisitable extends RewardableObject {

    public function new() {
        super();

        visitMode = VisitMode.VISIT_ONCE;
        selectMode = SelectMode.SELECT_FIRST;
    }
}
