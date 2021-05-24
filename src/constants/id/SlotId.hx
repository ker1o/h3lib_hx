package constants.id;

@:forward(getNum)
abstract SlotId(BaseForId) {
    public function new(num:Int) {
        this = num;
    }

    public function	validSlot() {
        return this.getNum() >= 0  && this.getNum() < GameConstants.ARMY_SIZE;
    }
}
