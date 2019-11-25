package lib.herobonus;

@:forward(push, iterator)
abstract BonusList(Array<Bonus>) {
  public function new() {
        this = [];
  }
}
