package mapping;

/// The pattern data can be visualized as a 3x3 matrix:
/// [ ][ ][ ]
/// [ ][ ][ ]
/// [ ][ ][ ]
///
/// The box in the center belongs always to the native terrain type and
/// is the point of origin. Depending on the terrain type different rules
/// can be used. Their meaning differs also from type to type.
///
class TerrainViewPattern {

    public static inline var PATTERN_DATA_SIZE:Int = 9;
    /// Constant for the flip mode different images. Pattern will be flipped and different images will be used(mapping area is divided into 4 parts)
    public static inline var FLIP_MODE_DIFF_IMAGES:String = "D";
    /// Constant for the rule dirt, meaning a dirty border is required.
    public static inline var RULE_DIRT:String = "D";
    /// Constant for the rule sand, meaning a sandy border is required.
    public static inline var RULE_SAND:String = "S";
    /// Constant for the rule transition, meaning a dirty OR sandy border is required.
    public static inline var RULE_TRANSITION:String = "T";
    /// Constant for the rule native, meaning a native border is required.
    public static inline var RULE_NATIVE:String = "N";
    /// Constant for the rule native strong, meaning a native type is required.
    public static inline var RULE_NATIVE_STRONG:String = "N!";
    /// Constant for the rule any, meaning a native type, dirty OR sandy border is required.
    public static inline var RULE_ANY:String = "?";


    /// Array -> several rules can be used in one cell
    public var data:Array<Array<WeightedRule>>;

    /// The identifier of the pattern, if it's referenced from a another pattern.
    public var id:String;

    /// This describes the mapping between this pattern and the corresponding range of frames
    /// which should be used for the ter view.
    ///
    /// Array -> size=1: typical, size=2: if this pattern should map to two different types of borders
    /// {lowerRange:Int, upperRange:Int}   -> 1st value: lower range, 2nd value: upper range
    public var mapping:Array<{lowerRange:Int, upperRange:Int}>;
    /// If diffImages is true, different images/frames are used to place a rotated terrain view. If it's false
    /// the same frame will be used and rotated.
    public var diffImages:Bool;
    /// The rotationTypesCount is only used if diffImages is true and holds the number how many rotation types(horizontal, etc...)
    /// are supported.
    public var rotationTypesCount:Int;

    /// The minimum and maximum poInts to reach to validate the pattern successfully.
    public var minPoints:Int;
    public var maxPoints:Int;

    public function new() {
        data = [for (i in 0...PATTERN_DATA_SIZE) []];
        mapping = [];
        maxPoints = 0x7FFFFFFF;
    }
}
