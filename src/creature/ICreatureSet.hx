package creature;

import constants.GameConstants.TQuantity;
import constants.id.CreatureId;
import constants.CreatureType;
import constants.id.SlotId;

typedef TSlots = Map<SlotId, StackInstance>;
typedef TSimpleSlots = Map<SlotId, {creatureId:CreatureType, quantity:Int}>;

interface ICreatureSet {
    var stacks(get, set):TSlots;
    var formation(get, set):Bool;
    function setCreature(slot:SlotId, cre:CreatureType, count:Int):Bool;
    function clear():Void;
    function putStack(slot:SlotId, stack:StackInstance):Void;
    function validTypes(allowUnrandomized:Bool):Bool;
    function slotEmpty(slot:SlotId):Bool;
    function addToSlot(slot:SlotId, cre:CreatureId, count:TQuantity, allowMerging:Bool = false):Void;
    function getStack(slot:SlotId):StackInstance;
}
