package lib.constants;

@:enum abstract Alignment(Int) from Int to Int {
    public var GOOD:Int = 0;
    public var EVIL:Int = 1;
    public var NEUTRAL:Int = 2;

    public static function parse(strValue:String):Alignment {
        return switch(strValue) {
            case "GOOD": GOOD;
            case "EVIL": EVIL;
            case "NEUTRAL": NEUTRAL;
            default: NEUTRAL;
        }
    }
}
