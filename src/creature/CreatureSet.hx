package creature;

import constants.CreatureType;
import constants.id.SlotId;
import creature.ICreatureSet.TSlots;

class CreatureSet implements IArmyDescriptor implements ICreatureSet {
    @:isVar public var stacks(get, set):TSlots; //slots[slot_id]->> pair(creature_id,creature_quantity)
    @:isVar public var formation(get, set):Bool; //false - wide, true - tight

    public function new() {
        stacks = new TSlots();
        formation = false;
    }

    private function get_stacks():TSlots {
        return stacks;
    }

    private function set_stacks(value:TSlots) {
        return stacks = value;
    }

    private function get_formation():Bool {
        return formation;
    }

    private function set_formation(value:Bool) {
        return formation = value;
    }

    public function setCreature(slot:SlotId, cre:CreatureType, count:Int):Bool { /*slots 0 to 6 */
        //ToDo
        return true;
    }

    public function clear():Void {
        //ToDo
    }

    public function putStack(slot:SlotId, stack:StackInstance) {
        stacks[slot] = stack;
        armyChanged();
    }

    private function armyChanged() {

    }

    public function validTypes(allowUnrandomized:Bool):Bool {
        for(elem in stacks) {
            if(!elem.valid(allowUnrandomized))
                return false;
        }
        return true;
    }
}
