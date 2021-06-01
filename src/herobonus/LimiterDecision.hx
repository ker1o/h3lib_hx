package herobonus;

@:enum abstract LimiterDecision(Int) from Int to Int {
    var ACCEPT;
    var DISCARD;
    var NOT_SURE;
}