package netpacks;

import constants.id.SlotId;
import mapObjects.ArmedInstance;

class StackLocation {
    public var army:ArmedInstance;
    public var slot:SlotId;

    public function new(army:ArmedInstance, slot:SlotId) {
        this.army = army;
        this.slot = slot;
    }
}