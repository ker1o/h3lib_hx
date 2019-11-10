package lib.creature;

class StackBasicDescriptor {
    public var type:Creature;
    public var count:Int;

    public function new(creature:Creature = null, count:Int = -1) {
        this.type = creature;
        this.count = count;
    }
}
