package town;

@:enum abstract BuildMode(Int) from Int to Int {
    public var BUILD_NORMAL:Int = 0;  // 0 - normal, default
    public var BUILD_AUTO:Int = 1;   // 1 - auto - building appears when all requirements are built
    public var BUILD_SPECIAL:Int = 2; // 2 - special - building can not be built normally
    public var BUILD_GRAIL:Int = 3;    // 3 - grail - building reqires grail to be built
}
