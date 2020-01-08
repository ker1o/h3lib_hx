package mapObjects.rewardable;

// wagon, corpse, lean to, warriors tomb
import mapObjects.rewardable.RewardableObject.SelectMode;
import mapObjects.rewardable.RewardableObject.VisitMode;

class GOnceVisitable extends RewardableObject {

    public function new() {
        super();

        visitMode = VisitMode.VISIT_ONCE;
        selectMode = SelectMode.SELECT_FIRST;
    }
}
