package lib.mapping;

import lib.utils.Int3;
import lib.constants.MetaClass;

class EventCondition {
    public var object:Dynamic;
    public var metaType:MetaClass;
    public var value:Int;
    public var objectType:Int;
    public var objectSubtype:Int;
    public var objectInstanceName:String;
    public var position:Int3;
    public var condition:WinLoseType;

    public function new(condition:WinLoseType, value:Int = -1, objectType:Int = -1, position:Int3 = null) {
        object = null;
        metaType = MetaClass.INVALID;
        this.value = value;
        this.objectType = objectType;
        this.position = position == null ? new Int3(-1, -1, -1) : position;
        this.condition = condition;
    }

    public function toString() {
        return '{$condition:$value}';
    }
}
