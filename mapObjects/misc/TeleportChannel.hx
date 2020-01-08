package lib.mapObjects.misc;

import lib.constants.id.ObjectInstanceId;

class TeleportChannel {
    public var entrances:Array<ObjectInstanceId>;
    public var exits:Array<ObjectInstanceId>;
    public var passability:Passability;

    public function new() {
    }
}
