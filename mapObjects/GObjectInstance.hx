package lib.mapObjects;

import constants.id.ObjectInstanceId;
import constants.Obj;
import utils.Int3;
import constants.PlayerColor;

class GObjectInstance implements IObjectInterface {
    /// Position of bottom-right corner of object on map
    public var pos: Int3;
    /// Type of object, e.g. town, hero, creature.
    public var ID: Obj;
    /// Subtype of object, depends on type
    public var subID: Int;
    /// Index of object in map's list of objects
    public var id: ObjectInstanceId;
    /// Defines appearance of object on map (animation, blocked tiles, blit order, etc)
    public var appearance: ObjectTemplate;
    /// Current owner of an object (when below PLAYER_LIMIT)
    public var tempOwner: PlayerColor;
    /// If true hero can visit this object only from neighbouring tiles and can't stand on this object
    public var blockVisit: Bool;

    public var instanceName: String;
    public var typeName: String;
    public var subTypeName: String;

    public function new() {
    }
}
