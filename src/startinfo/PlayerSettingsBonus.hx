package startinfo;

@:enum abstract PlayerSettingsBonus(Int) from Int to Int {
    var NONE:Int = -2;
    var RANDOM:Int = -1;
    var ARTIFACT:Int = 0;
    var GOLD:Int = 1;
    var RESOURCE:Int = 2;
}