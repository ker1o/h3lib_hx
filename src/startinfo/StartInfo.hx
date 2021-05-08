package startinfo;

import constants.id.PlayerColor;

typedef TPlayerInfos = Map<PlayerColor, PlayerSettings>;

class StartInfo {
    public var mode:StartInfoMode;
    public var difficulty:Int; //0=easy; 4=impossible

    public var playerInfos:TPlayerInfos; //color indexed

    public var seedToBeUsed:Int; //0 if not sure (client requests server to decide, will be send in reply pack)
    public var seedPostInit:Int; //so we know that game is correctly synced at the start; 0 if not known yet
    public var mapfileChecksum:Int; //0 if not relevant
    public var turnTime:Int; //in minutes, 0=unlimited
    public var mapname:String; // empty for random map, otherwise name of the map or savegame

    public function new() {
        playerInfos = new TPlayerInfos();
    }
}
