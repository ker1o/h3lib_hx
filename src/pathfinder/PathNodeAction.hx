package pathfinder;

@:enum abstract PathNodeAction(Int) {
    var UNKNOWN = 0;
    var EMBARK = 1;
    var DISEMBARK;
    var NORMAL;
    var BATTLE;
    var VISIT;
    var BLOCKING_VISIT;
    var TELEPORT_NORMAL;
    var TELEPORT_BLOCKING_VISIT;
    var TELEPORT_BATTLE;
}