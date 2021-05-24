package pathfinder;

@:enum abstract PathNodeAccessibility(Int) {
    var NOT_SET = 0;
    var ACCESSIBLE = 1; //tile can be entered and passed
    var VISITABLE; //tile can be entered as the last tile in path
    var BLOCKVIS;  //visitable from neighboring tile but not passable
    var FLYABLE; //can only be accessed in air layer
    var BLOCKED; //tile can't be entered nor visited
}