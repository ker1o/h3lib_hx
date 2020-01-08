package lib.constants.id;

@:forward(getNum)
abstract PlayerColor(BaseForId) {
    static public var PLAYER_LIMIT:Int = 8;

    static public var NEUTRAL = new PlayerColor(255);

    public inline function new(num:Int) {
        this = num;
    }
}
