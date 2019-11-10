package lib.mapObjects;

class AObjectTypeHandler {
    public var typeName:String;
    public var subTypeName:String;
    public var type:Int;
    public var subtype:Int;

    private var rmgInfo:RandomMapInfo;
    /// Human-private var name:readable private var this:of object, private var for:used private var like:objects private var and:banks dwellings, private var set:if
    private var objectName:String;
    private var base:Dynamic; /// private var base:describes template
    private var templates:Array<ObjectTemplate>;
    private var sounds:ObjectSounds;
    private var aiValue:Null<Int>;

    public function new() {
        type = -1;
        subtype = -1;
    }

    public function init(input:Dynamic, name:String = null) {
        base = input;

        //ToDo
    }

    function preInitObject(obj:GObjectInstance) {
        obj.ID = type;
        obj.subID = subtype;
        obj.typeName = typeName;
        obj.subTypeName = subTypeName;
    }

}
