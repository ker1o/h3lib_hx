package lib.mapObjects.rewardable;

import lib.mapObjects.rewardable.RewardableObject.SelectMode;
import lib.mapObjects.rewardable.RewardableObject.VisitMode;

// campfire, treasure chest, Flotsam, Shipwreck Survivor, Sea Chest
class GPickable extends RewardableObject {

    public function new() {
        super();

        visitMode = VisitMode.VISIT_UNLIMITED;
        selectMode = SelectMode.SELECT_PLAYER;
    }
}
