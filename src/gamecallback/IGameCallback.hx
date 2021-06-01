package gamecallback;

import constants.Obj;
import mapObjects.GObjectInstance;
import utils.Int3;

interface IGameCallback {
    function putNewObject(ID:Obj, subID:Int, pos:Int3):GObjectInstance;

//    public function putNewMonster(creID:CreatureId, count:Int, pos:Int3):GCreature {
//
//    }

    //get info
//    function isVisitCoveredByAnotherQuery(obj:GObjectInstance, hero:GHeroInstance):Bool {
//
//    }

}