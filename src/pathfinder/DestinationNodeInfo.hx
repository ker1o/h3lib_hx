package pathfinder;

import gamestate.GameState;

class DestinationNodeInfo extends PathNodeInfo {
    public var action:PathNodeAction = PathNodeAction.UNKNOWN;
    public var turn:Int;
    public var movementLeft:Int;
    public var cost:Float; //same as CGPathNode::cost
    public var blocked:Bool = false;
    public var isGuardianTile:Bool;
    
    public function new() {
        super();
    }

    override public function setNode(gs:GameState, n:GPathNode, excludeTopObject:Bool = false) {
        super.setNode(gs, n, excludeTopObject);
        blocked = false;
        action = PathNodeAction.UNKNOWN;
    }
}