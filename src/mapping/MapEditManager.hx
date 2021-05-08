package mapping;

import mapping.editmanager.InsertObjectOperation;
class MapEditManager {
    var _map:MapBody;
//    var _undoManager:MapUndoManager;
//    var _terrainSel:TerrainSelection;
//    var _objectSel:ObjectSelection;

    public function new(map:MapBody) {
        _map = map;
    }

    public function insertObject() {
        execute(new InsertObjectOperation(_map, _obj));
    }

    function execute(operation:MapOperation) {
        operation.execute();
        // ToDo: add to undo manager
    }
}
