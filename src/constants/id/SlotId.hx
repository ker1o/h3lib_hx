package constants.id;

@:forward(getNum)
abstract SlotId(BaseForId) {
    public function new(num:Int) {
        this = num;
    }
}
