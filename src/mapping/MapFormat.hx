package mapping;

@:enum abstract MapFormat(Int) from Int to Int {
    public var INVALID = 0;
                //    HEX     DEC
    public var ROE = 0x0e; // 14
    public var AB  = 0x15; // 21
    public var SOD = 0x1c; // 28
    // HOTA = 0x1e ... 0x20 // 28 ... 30
    public var WOG = 0x33;  // 51
    public var VCMI = 0xF0;

    @:op(A > B)
    static function gt(a:MapFormat, b:MapFormat):Bool {
        return (a:Int) > (b:Int);
    }
}
