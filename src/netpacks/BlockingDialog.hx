package netpacks;

import constants.id.PlayerColor;

class BlockingDialog {
    private static var ALLOW_CANCEL = 1;
    private static var SELECTION = 2;

    public var text:MetaString;
    public var components:Array<Component>;
    public var player:PlayerColor;
    public var flags:Int;
    public var soundID:Int;

    public function new(yesno:Bool, selection:Bool) {
        flags = 0;
        soundID = 0;
        if (yesno) flags |= ALLOW_CANCEL;
        if (selection) flags |= SELECTION;
    }
}