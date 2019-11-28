package lib.herobonus;

@:forward(push, iterator)
abstract BonusList(Array<Bonus>) from Array<Bonus> to Array<Bonus>{
  public function new() {
        this = [];
  }
}
