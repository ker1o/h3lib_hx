package lib.mapObjects.misc;

import constants.id.TeleportChannelID;

class GTeleport extends GObjectInstance {
    public var channel:TeleportChannelID;

    private var type:TeleportType;

    public function new() {
        super();
    }
}

@:enum abstract TeleportType(Int) from Int to Int {
    public var UNKNOWN:Int = 0;
    public var ENTRANCE:Int = 1;
    public var EXIT:Int = 2;
    public var BOTH:Int = 3;
}