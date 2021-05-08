package mapping.editmanager;

class MapOperation {
    var _map:MapBody;

    public function new(map:MapBody) {
        this._map = map;
    }

    function execute():Void {
        throw "You must override this method";
    }

    function undo():Void {

    }

    function redo():Void {

    }
}