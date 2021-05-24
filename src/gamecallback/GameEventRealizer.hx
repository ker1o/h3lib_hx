package gamecallback;

import constants.id.ObjectInstanceId;
import constants.id.PlayerColor;
import netpacks.InfoWindow;
import netpacks.PackForClient;
import netpacks.SetObjectProperty;

class GameEventRealizer {
    public function new() {

    }

    public function commitPackage(pack:PackForClient) {
        throw "Implement GameEventRealizer.commitPackage()";
    }

    public function showInfoDialog(iw:InfoWindow) {
        commitPackage(iw);
    }

    public function setObjProperty(objid:ObjectInstanceId, prop:Int, val:Int) {
        var sob = new SetObjectProperty();
        sob.id = objid;
        sob.what = prop;
        sob.val = val;
        commitPackage(sob);
    }

    function showInfoDialogForPlayer(msg:String, player:PlayerColor) {
        var iw = new InfoWindow();
        iw.player = player;
        iw.text = msg;
        showInfoDialog(iw);
    }
}