package mapObjects.hero;

import utils.Int3;

class Patrol {
    public var patrolling:Bool;
    public var initialPos:Int3;
    public var patrolRadius:Int;

    public function new() {
        patrolling = false;
        initialPos = new Int3();
        patrolRadius = -1;
    }
}
