package netpacks;

class Component {
    public var id:ComponentType; //id uses ^^^ enums, when id==EXPPERIENCE subtype==0 means exp points and subtype==1 levels)
    public var subtype:Int;

    public var val:Int; // + give; - take
    public var when:Int; // 0 - now; +x - within public var days:x; -x - per x days

    public function new(type:ComponentType, subtype:Int, val:Int, when:Int) {
        id = type;
        this.subtype = subtype;
        this.val = val;
        this.when = when;
    }
}
