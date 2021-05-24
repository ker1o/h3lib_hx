package utils;

class Int3 {
    public var x:Int;
    public var y:Int;
    public var z:Int;

    public function new(x:Int = 0, y:Int = 0, z:Int = 0) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public function toString():String {
        return 'x: $x, y: $y, z: $z';
    }

    public function valid() {
        return z >= 0; //minimal condition that needs to be fulfilled for tiles in the map
    }

    public static function addition(a:Int3, b:Int3) {
        return new Int3(a.x + b.x, a.y + b.y, a.z + b.z);
    }

    public static function substraction(a:Int3, b:Int3) {
        return new Int3(a.x - b.x, a.y - b.y, a.z - b.z);
    }

    public inline function addComponents(xc:Int, yc:Int, zc:Int) {
        x += xc;
        y += yc;
        z += zc;
    }

    public function copy() {
        return new Int3(x, y, z);
    }

    public function add(other:Int3) {
        x += other.x;
        y += other.y;
        z += other.z;
    }

    public function sub(other:Int3) {
        x -= other.x;
        y -= other.y;
        z -= other.z;
    }
}

typedef HashInt3 = Int;

@:enum abstract DistanceFormula(Int) from Int to Int {
    var DIST_2D = 0;
    var DIST_MANHATTAN; // patrol distance
    var DIST_CHEBYSHEV; // ambient sound distance
    var DIST_2DSQ;
}
