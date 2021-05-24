package mapObjects;

import constants.GameConstants.TQuantity;
import constants.id.CreatureId;
import constants.CreatureType;
import constants.id.SlotId;
import battle.BattleInfo;
import creature.CreatureSet;
import creature.ICreatureSet;
import creature.StackInstance;
import herobonus.BonusSystemNode;

class ArmedInstance extends GObjectInstance implements ICreatureSet {
    public var battle:BattleInfo;

    public var stacks(get, set):TSlots;
    public var formation(get, set):Bool;

    // multiple inheritance in VCMI
    public var bonusSystemNode(default, null):BonusSystemNode;
    private var _creatureSet(default, null):CreatureSet;

    public function new() {
        super();

        bonusSystemNode = new BonusSystemNode();
        _creatureSet = new CreatureSet();
    }

    //ICreatureSet implementations
    private function get_stacks():TSlots {
        return _creatureSet.stacks;
    }

    private function set_stacks(value:TSlots) {
        return _creatureSet.stacks = value;
    }

    private function get_formation():Bool {
        return _creatureSet.formation;
    }

    private function set_formation(value:Bool) {
        return _creatureSet.formation = value;
    }

    public function setCreature(slot:SlotId, cre:CreatureType, count:Int):Bool {
        return _creatureSet.setCreature(slot, cre, count);
    }

    public function clear():Void {
        _creatureSet.clear();
    }

    public function putStack(slot:SlotId, stack:StackInstance):Void {
        _creatureSet.putStack(slot, stack);
        stack.setArmyObj(this);
    }

    public function validTypes(allowUnrandomized:Bool):Bool {
        return _creatureSet.validTypes(allowUnrandomized);
    }

    public function slotEmpty(slot:SlotId):Bool {
        return _creatureSet.slotEmpty(slot);
    }

    public function addToSlot(slot:SlotId, cre:CreatureId, count:TQuantity, allowMerging:Bool = false):Void {
        return _creatureSet.addToSlot(slot, cre, count, allowMerging);
    }
}
