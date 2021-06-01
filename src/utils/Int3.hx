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

    public function dist2dSQ(o:Int3) {
        var dx = (x - o.x);
        var dy = (y - o.y);
        return (dx*dx) + (dy*dy);
    }

    public function less(i:Int3) {
        if (z < i.z)
            return true;
        if (z > i.z)
            return false;
        if (y < i.y)
            return true;
        if (y > i.y)
            return false;
        if (x < i.x)
            return true;
        if (x > i.x)
            return false;
        return false;
    }

    public function equals(o:Int3) {
        return x == o.x && y == o.y && z == o.z;
    }

    public function dist(o:Int3, formula:DistanceFormula) {
        switch(formula) {
            case DIST_2D:
                return dist2d(o);
            case DIST_MANHATTAN:
                return mandist2d(o);
            case DIST_CHEBYSHEV:
                return chebdist2d(o);
            case DIST_2DSQ:
                return dist2dSQ(o);
            default:
                return 0;
        }
    }

    function dist2d(o:Int3) {
        return Math.sqrt(dist2dSQ(o));
    }
    //manhattan distance used for patrol radius (z coord is not used)
    function mandist2d(o:Int3) {
        return Math.abs(o.x - x) + Math.abs(o.y - y);
    }
    //chebyshev distance used for ambient sounds (z coord is not used)
    function chebdist2d(o:Int3) {
        return Math.max(Math.abs(o.x - x), Math.abs(o.y - y));
    }
}

typedef HashInt3 = Int;

@:enum abstract DistanceFormula(Int) from Int to Int {
    var DIST_2D = 0;
    var DIST_MANHATTAN; // patrol distance
    var DIST_CHEBYSHEV; // ambient sound distance
    var DIST_2DSQ;
}
