package netpacks;

import constants.id.ObjectInstanceId;

class SetObjectProperty extends PackForClient {
    public var id:ObjectInstanceId;
    public var what:Int; // see ObjProperty enum
    public var val:Int;

    public function new(id:ObjectInstanceId = null, what:Int = 0, val:Int = 0) {
        super();
        this.id = id;
        this.what = what;
        this.val = val;
    }
}