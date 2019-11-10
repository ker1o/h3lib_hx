package lib.mapping;

class WeightedRule {
    public var isStandardRule(default, null):Bool;
    public var isAnyRule(default, null):Bool;
    public var isDirtRule(default, null):Bool;
    public var isSandRule(default, null):Bool;
    public var isTransitionRule(default, null):Bool;
    public var isNativeStrongRule(default, null):Bool;
    public var isNativeRule(default, null):Bool;

    /// The name of the rule. Can be any value of the RULE_* constants or a ID of a another pattern.
    //FIXME: remove string variable altogether, use only in constructor
    public var name:String;
    /// Optional. A rule can have points. Patterns may have a minimum count of points to reach to be successful.
    public var points:Int;
    
    public function new(name:String) {
        this.name = name;
        points = 0;

        isStandardRule = (TerrainViewPattern.RULE_ANY == name || TerrainViewPattern.RULE_DIRT == name
        || TerrainViewPattern.RULE_NATIVE == name || TerrainViewPattern.RULE_SAND == name
        || TerrainViewPattern.RULE_TRANSITION == name || TerrainViewPattern.RULE_NATIVE_STRONG == name);
        isAnyRule = (name == TerrainViewPattern.RULE_ANY);
        isDirtRule = (name == TerrainViewPattern.RULE_DIRT);
        isSandRule = (name == TerrainViewPattern.RULE_SAND);
        isTransitionRule = (name == TerrainViewPattern.RULE_TRANSITION);
        isNativeStrongRule = (name == TerrainViewPattern.RULE_NATIVE_STRONG);
        isNativeRule = (name == TerrainViewPattern.RULE_NATIVE);
    }

    public function setNative() {
        isNativeRule = true;
        isStandardRule = true;
        //TODO: would look better as a bitfield
        isDirtRule = isSandRule = isTransitionRule = isNativeStrongRule = isNativeRule = false; //no idea what they mean, but look mutually exclusive
    }
}
