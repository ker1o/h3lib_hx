package gamestate;

import constants.CreatureType;
import constants.id.CreatureId;
import res.ResourceSet.TResources;

class UpgradeInfo {
    public var oldID:CreatureId; //creature to be upgraded
    public var newID:Array<CreatureId>; //possible upgrades
    public var cost:Array<TResources>; // cost[upgrade_serial] -> set of pairs<resource_ID,resource_amount>; cost is for single unit (not entire stack)

    public function new() {
        oldID = CreatureType.NONE;
    }
}