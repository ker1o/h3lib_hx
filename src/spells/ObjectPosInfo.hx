package spells;

import mapObjects.GObjectInstance;
import constants.id.PlayerColor;
import constants.Obj;
import utils.Int3;

class ObjectPosInfo {
    public var pos:Int3;
    public var id:Obj;
    public var subId:Int;
    public var owner:PlayerColor;

    public function new(obj:GObjectInstance = null) {
        if (obj != null) {
            pos = obj.visitablePos();
            id = obj.ID;
            subId = obj.subID;
            owner = obj.tempOwner;
        } else {
            pos = new Int3();
            id = Obj.NO_OBJ;
            subId = -1;
            owner = PlayerColor.CANNOT_DETERMINE;
        }
    }
}