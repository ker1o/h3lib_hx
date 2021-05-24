package constants.id;

@:forward(getNum)
abstract HeroTypeId(BaseForId) from Int to Int {
    public inline function new(value:Int) {
        this = value;
    }
}
