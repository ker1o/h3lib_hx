package startinfo;

import mapping.TeamID;
import constants.id.PlayerColor;

class PlayerSettings {
    public var bonus:PlayerSettingsBonus;
    public var castle:Int;
    public var hero:Int;
    public var heroPortrait:Int; //-1 if default, else ID

    public var heroName:String;
    public var color:PlayerColor; //from 0 -
//    enum EHandicap {NO_HANDICAP, MILD, SEVERE};
//    public var handicap:EHandicap;//0-no, 1-mild, 2-severe
    public var team:TeamID;

    public var name:String;
    public var connectedPlayerIDs:Array<Int>; //Empty - AI, or connectrd player ids
    public var compOnly:Bool; //true if this player is a computer only player. required for RMG

    public function new() {

    }

    public function isControlledByHuman():Bool {
        return connectedPlayerIDs.length > 0;
    }
}