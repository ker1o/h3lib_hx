package netpacks;

import utils.Int3;
import constants.id.ObjectInstanceId;
import constants.Obj;

class NewObject extends PackForClient {
    public var ID:Obj;
    public var subID:Int;
    public var pos:Int3;
    public var id:ObjectInstanceId; //used locally, filled during applyGs

    public function new() {
        super();
        subID = 0;
    }
}