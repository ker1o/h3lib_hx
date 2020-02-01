package constants.id;

@:forward(getNum)
abstract PlayerColor(BaseForId) {
    static public var PLAYER_LIMIT:Int = 8;

    static public var SPECTATOR = new PlayerColor(252);
    static public var CANNOT_DETERMINE = new PlayerColor(253);
    static public var UNFLAGGABLE = new PlayerColor(254);
    static public var NEUTRAL = new PlayerColor(255);

    public inline function new(num:Int) {
        this = num;
    }
}
