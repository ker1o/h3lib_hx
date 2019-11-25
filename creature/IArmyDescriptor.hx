package lib.creature;

import constants.CreatureType;
import constants.id.SlotId;

interface IArmyDescriptor {
    function setCreature(slot:SlotId, cre:CreatureType, count:Int):Bool;
    function clear():Void;
}
