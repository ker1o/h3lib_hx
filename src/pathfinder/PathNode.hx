package pathfinder;

import pathfinder.NodeAction;
import utils.Int3;

typedef Layer = PathfindingLayer;

class PathNode {
    public var theNodeBefore:PathNode;
    public var coord:Int3; //coordinates
    public var moveRemains:Int; //remaining tiles after hero reaches the tile
    public var turns:Int; //how many turns we have to wait before reachng the tile - 0 means current turn
    public var layer:Layer;
    public var accessible:Accessibility;
    public var action:NodeAction;
    public var locked:Bool;

    public function new() {
        coord = new Int3(-1, -1, -1);
        layer = Layer.WRONG;

        reset();
    }

    public function reset() {
        locked = false;
        accessible = Accessibility.NOT_SET;
        moveRemains = 0;
        turns = 255;
        theNodeBefore = null;
        action = NodeAction.UNKNOWN;
    }

    public function update(coord:Int3, layer:Layer, accessible:Accessibility) {
        if (layer == Layer.WRONG) {
            this.coord = coord.copy();
            this.layer = layer;
        } else {
            reset();
        }

        this.accessible = accessible;
    }

    public inline function reachable():Bool {
        return turns < 255;
    }


}