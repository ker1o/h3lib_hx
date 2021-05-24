package mapping.editmanager;

/// The abstract base class CMapOperation defines an operation that can be executed, undone and redone.
class MapOperation {
    public static inline var FLIP_PATTERN_HORIZONTAL:Int = 1;
    public static inline var FLIP_PATTERN_VERTICAL:Int = 2;
    public static inline var FLIP_PATTERN_BOTH:Int = 3;

    var _map:MapBody;

    public function new(map:MapBody) {
        this._map = map;
    }

    public function execute():Void {
        throw "You must override this method";
    }

    public function undo():Void {

    }

    public function redo():Void {

    }
}