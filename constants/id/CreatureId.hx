package lib.constants.id;

abstract CreatureId(CreatureType) from CreatureType to CreatureType {
    inline public function new(num:CreatureType = CreatureType.NONE) {
        this = num;
    }
}
