package pathfinder;

import pathfinder.PathNodeAccessibility;
import pathfinder.PathNode.Layer;
import utils.Int3;

class GPathNode {
    private static var MAX_FLOAT_VALUE:Float = 9007199254740991; // let's say it's max safe intefer for double

    public var theNodeBefore:GPathNode;
    public var coord:Int3 = new Int3(-1, -1, -1); //coordinates
    public var layer:Layer = PathfindingLayer.WRONG;
    public var moveRemains:Int; //remaining movement points after hero reaches the tile
    public var turns:Int; //how many turns we have to wait before reaching the tile - 0 means current turn

    public var accessible:PathNodeAccessibility;
    public var action:PathNodeAction;
    public var locked:Bool;
    public var inPQ:Bool;
    //ToDo: implement this date structure
//    public var pq:TFibHeap;

    var _cost:Float; //total cost of the path to this tile measured in turns with fractions

    public function new() {
        reset();
    }

    public function reset() {
        locked = false;
        accessible = PathNodeAccessibility.NOT_SET;
        moveRemains = 0;
        _cost = MAX_FLOAT_VALUE;
        turns = 255;
        theNodeBefore = null;
        action = PathNodeAction.UNKNOWN;
        inPQ = false;
//        pq = null;
    }
}