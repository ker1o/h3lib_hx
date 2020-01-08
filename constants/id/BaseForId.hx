package lib.constants.id;

abstract BaseForId(Int) from Int to Int {
    public inline function new(num:Int = -1) {
        this = num;
    }

    public inline function getNum():Int {
        return this;
    }
}
