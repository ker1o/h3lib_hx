package constants.id;

@:forward(getNum)
abstract TeleportChannelId(BaseForId) {
    public function new(num:Int = -1) {
        this = num;
    }
}
