package lib.mapObjects;

import constants.CreatureType;
import constants.id.SlotId;
import lib.battle.BattleInfo;
import lib.creature.CreatureSet;
import lib.creature.ICreatureSet;
import lib.creature.StackInstance;
import lib.herobonus.BonusSystemNode;

class ArmedInstance extends GObjectInstance implements ICreatureSet {
    public var battle:BattleInfo;

    public var stacks(get, set):TSlots;
    public var formation(get, set):Bool;

    // multiple inheritance in VCMI
    public var bonusSystemNode(default, null):BonusSystemNode;
    private var _creatureSet(default, null):ICreatureSet;

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
}
