package mapping;

class EventEffect {

    // effect type, using EType enum
    public var type:EventEffectType;

    // message that will be sent to other players
    public var toOtherMessage:String;

    public function new() {
    }
}

@:enum abstract EventEffectType(Int) from Int to Int {
    public var VICTORY:Int = 0;
    public var DEFEAT:Int = 1;
}
