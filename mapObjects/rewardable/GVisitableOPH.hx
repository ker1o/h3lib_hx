package lib.mapObjects.rewardable;

import lib.mapObjects.rewardable.RewardableObject.SelectMode;
import lib.mapObjects.rewardable.RewardableObject.VisitMode;

// objects visitable only once per hero
class GVisitableOPH extends RewardableObject {

    public function new() {
        super();

        visitMode = VisitMode.VISIT_HERO;
        selectMode = SelectMode.SELECT_PLAYER;
    }
}
