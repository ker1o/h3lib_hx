package mapping.editmanager;

import mapObjects.GObjectInstance;
import constants.id.ObjectInstanceId;

class InsertObjectOperation extends MapOperation {

    var _obj:GObjectInstance;

    public function new(map:MapBody, obj:GObjectInstance) {
        super(map);
        this._obj = obj;
    }

    override public function execute() {
        _obj.id = new ObjectInstanceId(_map.objects.length);
        _obj.instanceName = '${_obj.typeName}_${_obj.id.getNum()}';
        _map.addNewObject(_obj);
    }

}