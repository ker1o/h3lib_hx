package mapObjects.constructors;

import mapObjects.rewardable.RewardableObject;
import mapObjects.RandomRewardObjectInfo;

class RewardableConstructor extends AObjectTypeHandler {
    private var objectInfo:RandomRewardObjectInfo;

    public function new() {
        super();
    }

    override public function create(objTempl:ObjectTemplate):GObjectInstance {
        var ret = new RewardableObject();
        preInitObject(ret);
        ret.appearance = objTempl;
        return ret;
    }
}
