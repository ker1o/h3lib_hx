package mapObjects;

interface IBoatGenerator {
    function shipyardStatus():GeneratorState;
}

@:enum abstract GeneratorState(Int) from Int to Int {
    public var GOOD:Int = 0;
    public var BOAT_ALREADY_BUILT:Int = 1;
    public var TILE_BLOCKED:Int = 2;
    public var NO_WATER:Int = 3;
}
