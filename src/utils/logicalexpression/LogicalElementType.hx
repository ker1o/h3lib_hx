package utils.logicalexpression;

@:enum abstract LogicalElementType(Int) from Int to Int {
    public var NONE:Int = 0;
    public var SOME:Int = 1;
    public var ALL:Int = 2;

    public function toString() {
        return switch(this) {
            case NONE: "NONE";
            case SOME: "SOME";
            case ALL: "ALL";
            default: "?";
        }
    }
}
