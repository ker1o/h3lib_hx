package lib.creature;

import lib.constants.CreatureType;
import lib.constants.id.SlotId;

interface IArmyDescriptor {
    function setCreature(slot:SlotId, cre:CreatureType, count:Int):Bool;
    function clear():Void;
}
