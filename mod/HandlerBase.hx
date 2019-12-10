package lib.mod;

using Reflect;

class HandlerBase<TObjectId, TObject:Dynamic> implements IHandlerBase {
    public var objects:Array<TObject>;

    public function new() {
        objects = [];
    }

    public function loadObject(scope:String, name:String, data:Dynamic, index:UInt = 0) {
        var object = loadFromJson(data, normalizeIdentifier(scope, "core", name), index);

//        assert(objects[index] == nullptr); // ensure that this id was not loaded before
        objects[index] = object;

        for(type_name in getTypeNames()) {
            registerObject(scope, type_name, name, object.field("id"));
        }
    }

    public function loadFromJson(json:Dynamic, identifier:String, index:Int):TObject {
        throw "Must be overriden!";
    }

    public function getTypeNames():Array<String> {
        throw "Must be overriden!";
    }

    public function loadLegacyData(dataSize:Int):Array<Dynamic> {
        throw "Must be overriden!";
    }

    private inline function normalizeIdentifier(scope:String, remoteScope:String, identifier:String) {
        return ModHandler.normalizeIdentifier(scope, remoteScope, identifier);
    }

    private inline function registerObject(scope:String, type_name:String, name:String, index:Int) {
        return VLC.instance.modh.identifiers.registerObject(scope, type_name, name, index);
    }

}
