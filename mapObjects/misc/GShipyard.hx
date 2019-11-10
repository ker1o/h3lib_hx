package lib.mapObjects.misc;

import lib.res.ResType;

class GShipyard extends GObjectInstance implements IShipyard {

    public function new() {
        super();
    }

    public function getBoardCost():Array<Int> {
        var cost:Array<Int> = [];
        cost[ResType.WOOD] = 10;
        cost[ResType.GOLD] = 1000;
    }
}
