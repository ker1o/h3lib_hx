package lib.netpacks;

class MetaString {
    public var message:Array<Message>; //vector of EMessage

    public var localStrings:Array<{type:Int, serial:Int}>;
    public var exactStrings:Array<String>;
    public var numbers:Array<Int>;

    public function new() {
    }
}

@:enum abstract Message(Int) from Int to Int {
    public var EXACT_STRING:Int = 0;
    public var TLOCAL_STRING:Int = 1;
    public var TNUMBER:Int = 2;
    public var TREPLACE_ESTRING:Int = 3;
    public var TREPLACE_LSTRING:Int = 4;
    public var TREPLACE_NUMBER:Int = 5;
    public var TREPLACE_PLUSNUMBER:Int = 6;
}