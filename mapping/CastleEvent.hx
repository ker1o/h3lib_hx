package lib.mapping;

import constants.BuildingID;
import lib.mapObjects.town.GTownInstance;

class CastleEvent extends MapEvent {
    public var buildings:Array<BuildingID>; //from buildig list
    public var creatures:Array<Int>; //identifies its index on towns vector
    public var town:GTownInstance;

    public function new() {
        super();
    }
}
