package creature;

import mod.VLC;
import constants.GameConstants.TQuantity;
import constants.id.CreatureId;
import constants.CreatureType;
import constants.id.SlotId;
import creature.ICreatureSet.TSlots;

class CreatureSet implements IArmyDescriptor implements ICreatureSet {
    @:isVar public var stacks(get, set):TSlots; //slots[slot_id].> pair(creature_id,creature_quantity)
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

    public function setCreature(slot:SlotId, type:CreatureId, quantity:Int):Bool { /*slots 0 to 6 */
        if (!slot.validSlot()) {
            trace("Cannot set slot $slot");
            return false;
        }
        if (quantity == 0) {
            trace("Using set creature to delete stack?");
            eraseStack(slot);
            return true;
        }

        if(hasStackAtSlot(slot)) //remove old creature
            eraseStack(slot);

        putStack(slot, new StackInstance(type, quantity));
        return true;
    }

    public function getCreature(slot:SlotId) {
        return stacks.exists(slot) ? stacks.get(slot).stackBasicDescriptor.type : null;
    }

    public function clear():Void {
        var keys = stacks.keys();
        for (key in keys) {
            eraseStack(key);
        }
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

    public function getArmyStrength() {
        var ret = 0;
        for (stackInstance in stacks)
            ret += stackInstance.getPower();
        return ret;
    }

    public function slotEmpty(slot:SlotId) {
        return !hasStackAtSlot(slot);
    }

    public function hasStackAtSlot(slot:SlotId) {
        return stacks.exists(slot);
    }

    public function addToSlot(slot:SlotId, cre:CreatureId, count:TQuantity, allowMerging:Bool = false) {
        var c:Creature = VLC.instance.creh.creatures[cre];

        if(!hasStackAtSlot(slot)) {
            setCreature(slot, cre, count);
        } else if (getCreature(slot) == c && allowMerging) { //that slot was empty or contained same type creature
            setStackCount(slot, getStackCount(slot) + count);
        } else {
            trace("Failed adding to slot!");
        }
    }

    public function eraseStack(slot:SlotId) {
//        assert(hasStackAtSlot(slot));
        var toErase = detachStack(slot);
    }

    public function detachStack(slot:SlotId)
    {
//        assert(hasStackAtSlot(slot));
        var ret:StackInstance = stacks[slot];

        //if(CArmedInstance *armedObj = castToArmyObj())
        if(ret != null) {
            ret.setArmyObj(null); //detaches from current armyobj
//            assert(!ret.armyObj); //we failed detaching?
        }

        stacks.remove(slot);
        armyChanged();
        return ret;
    }
    
    public function setStackCount(slot:SlotId, count:TQuantity) {
//        assert(hasStackAtSlot(slot));
//        assert(stacks[slot].count + count > 0);
        if (VLC.instance.modh.modules.STACK_EXP && count > stacks[slot].stackBasicDescriptor.count)
            stacks[slot].experience = Std.int(stacks[slot].experience * (count / stacks[slot].stackBasicDescriptor.count));
        stacks[slot].stackBasicDescriptor.count = count;
        armyChanged();
    }

    public function getStackCount(slot:SlotId) {
        return stacks.exists(slot) ? stacks.get(slot).stackBasicDescriptor.count : 0;
    }

    public function getStack(slot:SlotId) {
        //assert(hasStackAtSlot(slot));
        if (hasStackAtSlot(slot)) {
            return stacks[slot];
        } else {
            return null;
        }
    }
}
