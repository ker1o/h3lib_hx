package mapObjects;

import gamecallback.IGameCallback;
import gamecallback.GameCallback;
import mod.VLC;
import mapping.TerrainTile;
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

    public static var cb:GameCallback;

    public function new() {
        // ?
        pos = new Int3(-1, -1, -1);
        ID = Obj.NO_OBJ;
        subID = -1;
        tempOwner = new PlayerColor(PlayerColor.UNFLAGGABLE);
        blockVisit = false;
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

    public function getLeft():Int {
        return pos.x - getWidth() + 1;
    }

    public function getTop():Int {
        return pos.y - getHeight() + 1;
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

    public function isVisitable() {
        return appearance.isVisitable();
    }

    public function coveringAt(x:Int, y:Int) {
        return appearance.isVisibleAt(pos.x - x, pos.y - y);
    }

    public function visitablePos():Int3 {
        return Int3.substraction(pos, getVisitableOffset());
    }

    public function setType(ID:Int, subID:Int) {
        var tile:TerrainTile = cb.gameState().map.getTileByInt3(visitablePos());

        this.ID = (ID:Obj);
        this.subID = subID;

        //recalculate blockvis tiles - new appearance might have different blockmap than before
        cb.gameState().map.removeBlockVisTiles(this, true);
        var handler = VLC.instance.objtypeh.getHandlerFor(ID, subID);
        if(handler == null) {
            trace("Unknown object type %d:%d at %s", ID, subID, visitablePos().toString());
            return;
        }
        if (handler.getTemplatesForTerrain(tile.terType).length > 0) {
            appearance = handler.getTemplatesForTerrain(tile.terType)[0];
        } else {
            appearance = handler.getTemplates()[0]; // get at least some appearance since alternative is crash
        }
        cb.gameState().map.addBlockVisTiles(this);
    }

    public function getObjectName() {
        return VLC.instance.objtypeh.getObjectName(ID, subID);
    }

    public function getOwner() {
        return tempOwner;
    }

    public function initObj() {
        if (ID == Obj.TAVERN) {
            blockVisit = true;
        }
    }

    public function getSightCenter() {
        return visitablePos();
    }

    public function getSightRadius() {
        return 3;
    }
}
