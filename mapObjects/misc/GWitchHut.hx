package lib.mapObjects.misc;

class GWitchHut extends TeamVisited {
    public var allowedAbilities:Array<Int>;
    public var ability:UInt;

    public function new() {
        super();

        allowedAbilities = [];
    }
}
