package lib.constants.id;

@:forward(getNum)
abstract ObjectInstanceId(BaseForId) {
    public inline function new(num:Int = -1) {
        this = num;
    }
}
