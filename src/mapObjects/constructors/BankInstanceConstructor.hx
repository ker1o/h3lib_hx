package mapObjects.constructors;

import mapObjects.Bank;

using Reflect;

class BankInstanceConstructor extends DefaultObjectTypeHandler<Bank> {
    // all banks of this type will be reset N days after clearing,
    public var bankResetDuration:Int;

    var levels:Array<Dynamic>;

    public function new() {
        super(Bank);
    }

    override function initTypeData(input:Dynamic) {
        levels = input.field("levels");
        bankResetDuration = input.field("resetDuration");
    }
}
