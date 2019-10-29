package lib.mod;

class IdentifierStorage {

    private var registeredObjects:Map<String, ObjectData>;

    public function new() {
    }

    public function registerStorage(scope:String, type:String, name:String, identifier:Int) {
        var data = new ObjectData(identifier, scope);

        var fullID:String = type + '.' + name;
//        checkIdentifier(fullID);
//        var mapping = {fullId:fullID, data:data};
        var registeredValue = registeredObjects.get(fullID);
        if (registeredValue != null) {
            throw 'IdentifierStorage.registerStorage() Error: object with the same fullID($fullID) is trying to be registered. Needs MultiMap!';
        } else {
            registeredObjects.set(fullID, data);
        }

    }
}
