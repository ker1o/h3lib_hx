package herobonus;

@:forward(push, remove, length, iterator)
abstract BonusList(Array<Bonus>) from Array<Bonus> to Array<Bonus>{
    public inline function new() {
        this = [];
    }

    public function back():Bonus {
        return this[this.length - 1];
    }
}
