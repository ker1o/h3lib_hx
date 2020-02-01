package pathfinder;

@:enum abstract Accessibility(Int) from Int to Int {
    public var NOT_SET = 0;
    public var ACCESSIBLE = 1; //tile can be entered and passed
    public var VISITABLE = 2; //tile can be entered as the last tile in path
    public var BLOCKVIS = 3;  //visitable from neighbouring tile but not passable
    public var FLYABLE = 4; //can only be accessed in air layer
    public var BLOCKED = 5; //tile can't be entered nor visited    
}