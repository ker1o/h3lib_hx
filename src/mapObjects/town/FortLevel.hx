package mapObjects.town;

@:enum abstract FortLevel(Int) from Int to Int {
    var NONE = 0;
    var FORT = 1;
    var CITADEL = 2;
    var CASTLE = 3;
}