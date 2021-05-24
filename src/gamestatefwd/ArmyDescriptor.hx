package gamestatefwd;

import mapObjects.ArmedInstance;
import creature.StackBasicDescriptor;
import constants.id.SlotId;

class ArmyDescriptor {

    public var isDetailed:Bool;
    var _map:Map<SlotId, StackBasicDescriptor>;

    public function new(army:ArmedInstance = null, detailed:Bool = false) {
        _map = new Map<SlotId, StackBasicDescriptor>();
        isDetailed = detailed;
        if (army != null) {
            for (slotId in army.stacks.keys()) {
                var stackInstance = army.stacks[slotId];
                if(detailed) {
                    _map.set(slotId, stackInstance.stackBasicDescriptor);
                } else {
                    _map.set(slotId, new StackBasicDescriptor(stackInstance.stackBasicDescriptor.type, stackInstance.getQuantityID()));
                }
            }
        }
    }

}