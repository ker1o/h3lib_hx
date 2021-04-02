package constants.id;

abstract CreatureId(CreatureType) from CreatureType to CreatureType from Int to Int {
    inline public function new(num:CreatureType = CreatureType.NONE) {
        this = num;
    }
}
