package gamecallback;

import mapObjects.ArmedInstance;
import mapObjects.GObjectInstance;
import constants.id.ObjectInstanceId;
import mapObjects.hero.GHeroInstance;
import mapObjects.town.GTownInstance;
import artifacts.ArtifactInstance;
import constants.id.ArtifactInstanceID;
import utils.Int3;
import mapping.TerrainTile;
import mapping.TeamID;
import constants.id.PlayerColor;
import playerstate.PlayerState;
import playerstate.TeamState;

class NonConstInfoCallback extends PrivilegedInfoCallback {
    public function new() {
        super();
    }

//    public function getPlayer(color:PlayerColor, verbose:Bool = true):PlayerState {
//    }

//    public function getTeam(teamID:TeamID):TeamState { //get team by team ID
//    }

//    public function getPlayerTeam(color:PlayerColor):TeamState { // get team by player color
//        return getPlayerTeam(color);
//    }

//    public function getHero(objid:ObjectInstanceId):GHeroInstance {
//    }
//
//    public function getTown(objid:ObjectInstanceId):GTownInstance {
//    }

    public function getTile(pos:Int3):TerrainTile {
        return _gs.map.getTileByInt3(pos);
    }

//    public function getArtInstance(aid:ArtifactInstanceID):ArtifactInstance {
//    }
//
//    public function getObjInstance(oid:ObjectInstanceId):GObjectInstance {
//    }
//
//    public function getArmyInstance(oid:ObjectInstanceId):ArmedInstance {
//    }
}