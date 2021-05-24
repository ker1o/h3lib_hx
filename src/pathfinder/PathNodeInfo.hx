package pathfinder;

import gamestate.GameState;
import constants.PlayerRelations;
import mapObjects.GObjectInstance;
import mapping.TerrainTile;
import utils.Int3;

class PathNodeInfo {
    public var node:GPathNode;
    public var nodeObject:GObjectInstance;
    public var tile:TerrainTile;
    public var coord:Int3 = new Int3(-1, -1, -1);
    public var guarded:Bool;
    public var objectRelations:PlayerRelations;

    public function new() {

    }
    
    public function setNode(gs:GameState, n:GPathNode, excludeTopObject:Bool = false) {
        node = n;

        if(coord != node.coord)
        {
            coord = node.coord;
            tile = gs.getTile(coord);
            nodeObject = tile.topVisitableObj(excludeTopObject);
        }

        guarded = false;        
    }
}