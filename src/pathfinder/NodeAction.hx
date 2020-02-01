package pathfinder;

@:enum abstract NodeAction(Int) from Int to Int {
    public var UNKNOWN = 0;
    public var EMBARK = 1;
    public var DISEMBARK = 2;
    public var NORMAL = 3;
    public var BATTLE = 4;
    public var VISIT = 5;
    public var BLOCKING_VISIT = 6;
    public var TELEPORT_NORMAL = 7;
    public var TELEPORT_BLOCKING_VISIT = 8;
    public var TELEPORT_BATTLE = 9;
}