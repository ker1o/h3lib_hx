package lib.mapObjects;

import mapping.MapBody;
import constants.id.ObjectInstanceId;
import constants.Obj;
import utils.Int3;
import constants.id.PlayerColor;

class GObjectInstance implements IObjectInterface {
    /// Position of bottom-right corner of object on map
    public var pos:Int3;
    /// Type of object, e.g. town, hero, creature.
    public var ID:Obj;
    /// Subtype of object, depends on type
    public var subID:Int;
    /// Index of object in map's list of objects
    public var id:ObjectInstanceId;
    /// Defines appearance of object on map (animation, blocked tiles, blit order, etc)
    public var appearance:ObjectTemplate;
    /// Current owner of an object (when below PLAYER_LIMIT)
    public var tempOwner:PlayerColor;
    /// If true hero can visit this object only from neighbouring tiles and can't stand on this object
    public var blockVisit:Bool;

    public var instanceName:String;
    public var typeName:String;
    public var subTypeName:String;

    public function new() {
    }

    public function setOwner(ow:PlayerColor) {
        tempOwner = ow;
    }

    public function afterAddToMap(map:MapBody) {
        //nothing here
    }

    public function getVisitableOffset():Int3 {
        return appearance.getVisitableOffset();
    }

    public function getWidth():Int {
        return appearance.getWidth();
    }

    public function getHeight():Int {
        return appearance.getHeight();
    }

    public function visitableAt(x:Int, y:Int):Bool {
        return appearance.isVisitableAt(pos.x - x, pos.y - y);
    }

    public function blockingAt(x:Int, y:Int):Bool {
        return appearance.isBlockedAt(pos.x - x, pos.y - y);
    }
}
