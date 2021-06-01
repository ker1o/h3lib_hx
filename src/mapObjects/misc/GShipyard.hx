package mapObjects.misc;

import utils.Int3;
import mapObjects.IBoatGenerator.GeneratorState;
import res.ResType;

class GShipyard extends GObjectInstance implements IShipyard {

    var _boatGenerator:BoatGenerator;

    public function new(o:GObjectInstance = null) {
        super();

        _boatGenerator = new BoatGenerator(o != null ? o : this);
        _boatGenerator.getOutOffsets = getOutOffsets;
    }

    public function getBoatCost():Array<Int> {
        var cost:Array<Int> = [];
        cost[ResType.WOOD] = 10;
        cost[ResType.GOLD] = 1000;
        return cost;
    }

    public function shipyardStatus():GeneratorState {
        return _boatGenerator.shipyardStatus();
    }

    public function getOutOffsets(offsets:Array<Int3>)
    {
        // H J L K I
        // A x S x B
        // C E G F D
        var offsetsInternal = [
            new Int3(-3,0,0), new Int3(1,0,0), //AB
            new Int3(-3,1,0), new Int3(1,1,0), new Int3(-2,1,0), new Int3(0,1,0), new Int3(-1,1,0), //CDEFG
            new Int3(-3,-1,0), new Int3(1,-1,0), new Int3(-2,-1,0), new Int3(0,-1,0), new Int3(-1,-1,0) //HIJKL
        ];

        for (offset in offsetsInternal) {
            offsets.push(offset);
        }
    }
}
