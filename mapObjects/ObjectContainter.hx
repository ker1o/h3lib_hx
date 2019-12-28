package lib.mapObjects;

/// Small internal structure that contains information on specific group of objects
/// (creating separate entity is overcomplicating at least at this point)
import lib.mapObjects.ObjectClassesHandler.TObjectTypeHandler;

class ObjectContainter {

    public var id: Int;
    public var identifier: String;
    public var name: String; // human-readable name
    public var handlerName: String; // ID of handler that controls this object, should be determined using handlerConstructor map

    public var base:Dynamic;
    public var subObjects:Map<Int, TObjectTypeHandler>;
    public var subIds:Map<String, Int>;//full id from core scope -> subtype

    public var sounds:ObjectSounds;

    public var groupDefaultAiValue:Null<Int>;

    public function new() {
        subObjects = new Map<Int, TObjectTypeHandler>();
        subIds = new Map<String, Int>();
    }
}
