package lib.res;

abstract ResourceSet(Array<Int>) {
    public function new(wood:Int, mercury:Int, ore:Int, sulfur:Int, crystal:Int, gems:Int, gold:Int, mithril:Int) {
        this = [wood, mercury, ore, sulfur, crystal, gems, gold, mithril];
    }
}
