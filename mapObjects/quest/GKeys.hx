package lib.mapObjects.quest;

import constants.id.PlayerColor;

//Base class for Keymaster and guards
class GKeys extends GObjectInstance {
    //SubID 0 - lightblue, 1 - green, 2 - red, 3 - darkblue, 4 - brown, 5 - purple, 6 - white, 7 - black
    static var playerKeyMap:Map<PlayerColor, Array<Int>>; //warn: values are set; [players][keysowned]

    public function new() {
        super();
    }

    public function wasMyColorVisited(player:PlayerColor) {
        return playerKeyMap.exists(player) && playerKeyMap[player].indexOf(subID) > -1;
    }
}
