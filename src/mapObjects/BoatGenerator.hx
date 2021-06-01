package mapObjects;

import utils.Int3;
import constants.Obj;
import mapping.TerrainType;
import utils.Int3;
import mapObjects.IBoatGenerator;

class BoatGenerator implements IBoatGenerator {
    public var o:GObjectInstance;

    // delegate
    public var getOutOffsets:Array<Int3>->Void;

    public function new(o:GObjectInstance) {
        this.o = o;
    }

    public function shipyardStatus():GeneratorState {
        var tile = bestLocation();
        var t = GObjectInstance.cb.getTileByInt3(tile);
        if (t == null) {
            return TILE_BLOCKED; //no available water
        } else if (t.blockingObjects.length == 0) {
            return GOOD; //OK
        } else if (t.blockingObjects[0].ID == Obj.BOAT) {
            return BOAT_ALREADY_BUILT; //blocked with boat
        } else {
            return TILE_BLOCKED; //blocked
        }
    }

    public function bestLocation() {
        var offsets:Array<Int3> = [];
        getOutOffsets(offsets);

        for (offset in offsets) {
            var tile = GObjectInstance.cb.getTileByInt3(Int3.addition(o.pos, offset), false);
            if (tile != null) {//tile is in the map
                if(tile.terType == TerrainType.WATER  &&  (!tile.blocked || tile.blockingObjects[0].ID == Obj.BOAT)) { //and is water and is not blocked or is blocked by boat
                    return Int3.addition(o.pos, offset);
                }
            }
        }
        return new Int3(-1,-1,-1);
    }

}