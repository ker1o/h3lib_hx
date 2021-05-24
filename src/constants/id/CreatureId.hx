package constants.id;

import mod.VLC;

abstract CreatureId(CreatureType) from CreatureType to CreatureType from Int to Int {
    inline public function new(num:CreatureType = CreatureType.NONE) {
        this = num;
    }

    public function toCreature() {
        return VLC.instance.creh.creatures[this];
    }
}
