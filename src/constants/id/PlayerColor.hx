package constants.id;

import mod.VLC;
@:forward(getNum)
abstract PlayerColor(BaseForId) from Int to Int {
    static public var PLAYER_LIMIT:Int = 8;

    static public var SPECTATOR = 252;
    static public var CANNOT_DETERMINE = 253;
    static public var UNFLAGGABLE = 254;
    static public var NEUTRAL = 255;

    public inline function new(num:Int) {
        this = num;
    }

    public inline function isSpectator() {
        return this.getNum() == SPECTATOR;
    }

    public function isValidPlayer():Bool {
        return this.getNum() < PLAYER_LIMIT;
    }

    public function getStr(L10n:Bool = false) {
        var ret:String = "unnamed";
        if(isValidPlayer())
        {
            if(L10n)
                ret = VLC.instance.generaltexth.colors[this];
            else
                ret = StringConstants.PLAYER_COLOR_NAMES[this];
        }
        else if(L10n)
        {
            ret = VLC.instance.generaltexth.allTexts[508];
            ret = ret.substr(0, 1).toLowerCase() + ret.substr(1, ret.length - 1);
        }

        return ret;
    }
}
