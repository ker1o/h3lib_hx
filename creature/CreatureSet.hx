package lib.creature;

import constants.CreatureType;
import constants.id.SlotId;

private typedef TSlots = Map<SlotId, StackInstance>;
private typedef TSimpleSlots = Map<SlotId, {creatureId:CreatureType, quantity:Int}>;

class CreatureSet implements IArmyDescriptor {
    public var stacks:TSlots; //slots[slot_id]->> pair(creature_id,creature_quantity)
    public var formation:Bool; //false - wide, true - tight

    public function new() {
        formation = false;
    }

    public function setCreature(slot:SlotId, cre:CreatureType, count:Int):Bool { /*slots 0 to 6 */
        //ToDo
        return true;
    }

    public function clear():Void {
        //ToDo
    }
}
