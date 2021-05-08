package playerstate;

import constants.id.PlayerColor;
import mapping.TeamID;

class TeamState {
    public var id:TeamID; //position in gameState::teams
    public var players:Array<PlayerColor>; // members of this team
    //TODO: boost::array, bool if possible
    public var fogOfWarMap:Array<Array<Array<Bool>>>; //true - visible, false - hidden

    public function new() {
        players = [];
        fogOfWarMap = [[[]]];
    }

}