package mapObjects.misc;

import mapping.TeamID;

class GObelisk extends TeamVisited {
    static public var OBJPROP_INC:Int = 20;
    static public var obeliskCount:Int; //how many obelisks are on map
    static public var visited = new Map<TeamID, Int>(); //map: team_id => how many obelisks has been visited

    public function new() {
        super();
    }
}
