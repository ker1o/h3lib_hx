package town;

import constants.BuildingID;
import creature.Creature.Resources;
import utils.logicalexpression.LogicalExpression;

/// a typical building encountered in every castle ;]
/// this is structure available to both client and server
/// contains all mechanics-related data about town structures
class Building {
    public var town:Town; // town this building belongs to
    public var resources:Resources;
    public var produce:Resources;
    public var requirements:LogicalExpression<BuildingID>;
    public var identifier:String;

    public var bid:BuildingID; //structure ID
    public var upgrade:BuildingID; /// indicates that building "upgrade" can be improved by this, -1 = empty

    public var mode:BuildMode;
    public var height:TowerHeight;

    public var name:String;
    public var description:String;

    public function new() {
    }
}
