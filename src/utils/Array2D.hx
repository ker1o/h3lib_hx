package utils;

class Array2D<T> {
    public var data:Array<T> = [];
    public var rows:Int = 0;
    public var cols:Int = 0;

    public var length(get, never):Int;

    public function new(cols:Int = 0, rows:Int = 0) {
        this.cols = cols;
        this.rows = rows;
    }

    inline public function set(row:Int, col:Int, value:T) {
        data[row * cols + col] = value;
    }

    inline public function get(row:Int, col:Int):T {
        return data[row * cols + col];
    }

    public function reset(cols:Int, rows:Int) {
        this.rows = rows;
        this.cols = cols;
    }

    function get_length():Int {
        return rows * cols;
    }
}