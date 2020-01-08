package mod;

class ObjectCallback {
    public var localScope:String;  /// scope from which this ID was requested
    public var remoteScope:String; /// scope in which this object must be found
    public var type:String;        /// type, e.g. creature, faction, hero, etc
    public var name:String;        /// string ID
    public var callback:Int->Void;
    public var optional:Bool;
    
    public function new(localScope:String, remoteScope:String, type:String, name:String, callback:Int->Void, optional:Bool) {
        this.localScope = localScope;
        this.remoteScope = remoteScope;
        this.type = type;
        this.name = name;
        this.callback = callback;
        this.optional = optional;
    }
}
