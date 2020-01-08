package mapObjects;

/// Structure that describes placement rules for this object in random map
class RandomMapInfo {
    /// How valuable this object is, 1k = worthless, 10k = Utopia-level
    public var value:Int;

    /// How many of such objects can be placed on map, 0 = object can not be placed by RMG
    public var mapLimit:Int;

    /// How many of such objects can be placed in one zone, 0 = unplaceable
    public var zoneLimit:Int;

    /// Rarity of object, 5 = extremely rare, 100 = common
    public var rarity:Int;

    public function new() {
    }
}
