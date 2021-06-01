package gamecallback;

/// Class for handling general game logic and actions
import netpacks.NewObject;
import constants.id.CreatureId;
import mapObjects.hero.GHeroInstance;
import mapObjects.misc.GCreature;
import mapObjects.GObjectInstance;
import utils.Int3;
import constants.Obj;

class GameCallback extends PrivilegedInfoCallback implements IGameCallback {
    private var gameEventCallback:GameEventCallback;

    public function new() {
        super();
        gameEventCallback = new GameEventCallback();
    }

    //do sth
    public function putNewObject(ID:Obj, subID:Int, pos:Int3):GObjectInstance {
        var no = new NewObject();
        no.ID = ID; //creature
        no.subID= subID;
        no.pos = pos;
        gameEventCallback.commitPackage(no);
        return getObj(no.id); //id field will be filled during applying on gs
    }

//    public function putNewMonster(creID:CreatureId, count:Int, pos:Int3):GCreature {
//
//    }

    //get info
//    function isVisitCoveredByAnotherQuery(obj:GObjectInstance, hero:GHeroInstance):Bool {
//
//    }
}