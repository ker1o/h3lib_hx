package lib.mapObjects.misc;

/// Legacy class, use CRewardableObject instead
import lib.constants.id.PlayerColor;

class TeamVisited extends GObjectInstance {
    public var players:Array<PlayerColor>; //warn: a set; players that visited this object

    public function new() {
        super();
    }
}
