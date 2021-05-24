package constants;

@:enum abstract PlayerRelations(Int) from Int to Int {
    var ENEMIES;
    var ALLIES;
    var SAME_PLAYER;
}