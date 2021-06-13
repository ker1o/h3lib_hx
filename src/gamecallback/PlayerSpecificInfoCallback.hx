package gamecallback;

import constants.id.PlayerColor;
import gamestate.GameState;

class PlayerSpecificInfoCallback extends GameInfoCallback {
    public function new(gs:GameState = null, player:Null<PlayerColor> = null) {
        super(gs, player);
    }

    public function getVisibilityMap():Array<Array<Array<Bool>>> {
        return _gs.getPlayerTeam(_player).fogOfWarMap;
    }
}