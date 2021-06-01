package mapObjects.constructors;

import mod.VLC;
import constants.id.PlayerColor;
import town.Faction;
import constants.BuildingID;
import mapObjects.town.GTownInstance;
import utils.logicalexpression.LogicalExpression;

using Reflect;

class TownInstanceConstructor extends DefaultObjectTypeHandler<GTownInstance> {
    public var faction:Faction;
    public var filters:Map<String, LogicalExpression<BuildingID>>;

    private var _filtersJson:Dynamic;

    public function new() {
        super(GTownInstance);
    }

    override public function create(objTempl:ObjectTemplate):GObjectInstance {
        var obj:GTownInstance = createTyped(objTempl);
        obj.town = faction.town;
        obj.tempOwner = PlayerColor.NEUTRAL;
        return obj;
    }

    override function initTypeData(input:Dynamic) {
        var name = input.field("faction");
        var meta = "core";
        VLC.instance.modh.identifiers.requestIdentifierByNodeName("faction", name, meta, function(index:Int) {
            faction = VLC.instance.townh.factions[index];
        });

        _filtersJson = input.field("filters");
    }
}
