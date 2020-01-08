package mapObjects.town;

import constants.BuildingID;

///basic class for town structures handled as map objects
class GTownBuilding implements IObjectInterface {
    public var ID:BuildingID; //from buildig list
    public var id:Int; //identifies its index on towns vector
    public var town:GTownInstance;

    public function new() {
    }
}
