package lib.mapObjects.constructors;

import lib.town.Faction;
import constants.BuildingID;
import lib.mapObjects.town.GTownInstance;
import utils.logicalexpression.LogicalExpression;

class TownInstanceConstructor extends DefaultObjectTypeHandler<GTownInstance> {
    public var faction:Faction;
    public var filters:Map<String, LogicalExpression<BuildingID>>;

    public function new() {
        super(GTownInstance);
    }
}
