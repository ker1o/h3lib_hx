package mapObjects;

@:keep
class Bank extends ArmedInstance {
    public var bc:BankConfig;
    public var daycounter:Int;
    public var resetDuration:Int;

    public function new() {
        super();

        daycounter = 0;
        resetDuration = 0;
    }
}
