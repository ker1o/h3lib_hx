package creature;

import constants.id.CreatureId;
import constants.id.SlotId;

interface IArmyDescriptor {
    function setCreature(slot:SlotId, type:CreatureId, quantity:Int):Bool;
    function clear():Void;
}
