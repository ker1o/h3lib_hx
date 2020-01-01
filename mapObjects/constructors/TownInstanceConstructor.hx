package lib.mapObjects.constructors;

import constants.id.PlayerColor;
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

    override public function create(objTempl:ObjectTemplate):GObjectInstance {
        var obj:GTownInstance = createTyped(objTempl);
        obj.town = faction.town;
        obj.tempOwner = PlayerColor.NEUTRAL;
        return obj;
    }

}
