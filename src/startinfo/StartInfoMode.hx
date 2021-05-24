package startinfo;

@:enum abstract StartInfoMode(Int) from Int to Int {
    var NEW_GAME:Int = 0;
    var LOAD_GAME:Int = 1;
    var CAMPAIGN:Int = 2;
    var INVALID:Int = 255;
}