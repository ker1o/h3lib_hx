package lib.mapping;

@:enum abstract VictoryConditionType(Int) from Int to Int {
    public var ARTIFACT:Int = 0;
    public var GATHERTROOP:Int = 1;
    public var GATHERRESOURCE:Int = 2;
    public var BUILDCITY:Int = 3;
    public var BUILDGRAIL:Int = 4;
    public var BEATHERO:Int = 5;
    public var CAPTURECITY:Int = 6;
    public var BEATMONSTER:Int = 7;
    public var TAKEDWELLINGS:Int = 8;
    public var TAKEMINES:Int = 9;
    public var TRANSPORTITEM:Int = 10;
    public var WINSTANDARD = 255;
}
