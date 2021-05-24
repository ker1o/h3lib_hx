package res;

@:forward(length)
abstract ResourceSet(Array<Int>) from Array<Int> to Array<Int> {
    public function new(wood:Int = 0, mercury:Int = 0, ore:Int = 0, sulfur:Int = 0, crystal:Int = 0, gems:Int = 0, gold:Int = 0, mithril:Int = 0) {
        this = [wood, mercury, ore, sulfur, crystal, gems, gold, mithril];
    }

    @:op(A + B)
    public function opSum(other:ResourceSet):ResourceSet {
        var res = new ResourceSet();

        for (i in 0...this.length) {
            res[i] = this[i] + other[i];
        }
        return res;
    }

    public function add(other:ResourceSet) {
        for (i in 0...this.length) {
            this[i] = this[i] + other[i];
        }
    }
}

typedef TResources = ResourceSet;