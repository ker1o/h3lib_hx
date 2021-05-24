package gamecallback;

import battle.BattleInfo;
import constants.id.PlayerColor;

//Basic class for various callbacks (interfaces called by players to get info about game and so forth)
class CallbackBase {
    var _battle:BattleInfo; //battle to which the player is engaged, nullptr if none or not applicable
    var _player:Null<PlayerColor>; // not set gives access to all information, otherwise callback provides only information "visible" for player

    function new() {

    }

//    public function getPlayerID():Null<PlayerColor> {
//
//    }
//
//    function getBattle():BattleInfo {
//
//    }

}