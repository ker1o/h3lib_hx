package mapObjects.misc;

import constants.id.TeleportChannelId;

class GTeleport extends GObjectInstance {
    public var channel:TeleportChannelId;

    private var type:TeleportType;

    public function new() {
        super();
    }

    public function isEntrance() {
        return type == BOTH || type == ENTRANCE;
    }

    public function isExit() {
        return type == BOTH || type == EXIT;
    }
}

@:enum abstract TeleportType(Int) from Int to Int {
    public var UNKNOWN:Int = 0;
    public var ENTRANCE:Int = 1;
    public var EXIT:Int = 2;
    public var BOTH:Int = 3;
}