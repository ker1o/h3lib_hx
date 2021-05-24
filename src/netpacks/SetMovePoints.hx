package netpacks;

import constants.id.ObjectInstanceId;

class SetMovePoints {
    public var hid:ObjectInstanceId;
    public var val:Int;
    public var absolute:Bool;

    public function new() {
        val = 0;
        absolute = true;
    }
}