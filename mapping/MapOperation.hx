package lib.mapping;

/// The abstract base class CMapOperation defines an operation that can be executed, undone and redone.
class MapOperation {
    public function new() {
    }

    public static inline var FLIP_PATTERN_HORIZONTAL:Int = 1;
    public static inline var FLIP_PATTERN_VERTICAL:Int = 2;
    public static inline var FLIP_PATTERN_BOTH:Int = 3;
}
