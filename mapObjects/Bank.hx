package lib.mapObjects;

class Bank {
    public var bc:BankConfig;
    public var daycounter:Int;
    public var resetDuration:Int;

    public function new() {
        daycounter = 0;
        resetDuration = 0;
    }
}
