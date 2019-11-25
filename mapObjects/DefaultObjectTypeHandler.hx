package lib.mapObjects;

class DefaultObjectTypeHandler<T:GObjectInstance> extends AObjectTypeHandler {
    private var _clsT:Class<T>;

    public function new(clsT:Class<T>) {
        super();
        
        _clsT = clsT;
    }

    function createTyped(tmpl:ObjectTemplate):T {
        var obj:T = Type.createInstance(_clsT, []);
        preInitObject(obj);
        obj.appearance = tmpl;
        return obj;
    }
}
