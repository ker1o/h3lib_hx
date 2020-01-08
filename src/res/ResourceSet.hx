package res;

abstract ResourceSet(Array<Int>) from Array<Int> to Array<Int> {
    public function new(wood:Int = 0, mercury:Int = 0, ore:Int = 0, sulfur:Int = 0, crystal:Int = 0, gems:Int = 0, gold:Int = 0, mithril:Int = 0) {
        this = [wood, mercury, ore, sulfur, crystal, gems, gold, mithril];
    }
}
