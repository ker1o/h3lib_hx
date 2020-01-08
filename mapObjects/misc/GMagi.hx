package lib.mapObjects.misc;

import lib.constants.id.ObjectInstanceId;

class GMagi extends GObjectInstance {
    //[subID][id], supports multiple sets as in H5
    static public var eyelist:Map<Int, Array<ObjectInstanceId>>;

    public function new() {
        super();
    }
}
