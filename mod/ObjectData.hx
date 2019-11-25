package lib.mod;

// entry created on ID registration
abstract ObjectData({id:Int, scope:String}) {

    public var id(get, never):Int;
    public var scope(get, never):String;

    public inline function new(id:Int, scope:String) {
        this = {id:id, scope:scope};
    }

    public inline function get_id():Int {return this.id;}

    public inline function get_scope():String {return this.scope;}

    @:op(A==B) public inline function equals(x:ObjectData) return this.id == x.id && this.scope == x.scope;

}
