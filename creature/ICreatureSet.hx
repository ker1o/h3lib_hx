package lib.creature;

import lib.constants.CreatureType;
import lib.constants.id.SlotId;

typedef TSlots = Map<SlotId, StackInstance>;
typedef TSimpleSlots = Map<SlotId, {creatureId:CreatureType, quantity:Int}>;

interface ICreatureSet {
    var stacks(get, set):TSlots;
    var formation(get, set):Bool;
    function setCreature(slot:SlotId, cre:CreatureType, count:Int):Bool;
    function clear():Void;
    function putStack(slot:SlotId, stack:StackInstance):Void;
    function validTypes(allowUnrandomized:Bool):Bool;
}
