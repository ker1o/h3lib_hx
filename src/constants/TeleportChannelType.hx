package constants;

@:enum abstract TeleportChannelType(Int) from Int to Int {
    var IMPASSABLE;
    var BIDIRECTIONAL;
    var UNIDIRECTIONAL;
    var MIXED;
}