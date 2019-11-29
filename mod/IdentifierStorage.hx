package lib.mod;

class IdentifierStorage {

    private var registeredObjects:Map<String, ObjectData>;
    private var scheduledRequests:Array<ObjectCallback>;
    private var state:LoadingState;

    public function new() {
        registeredObjects = new Map<String, ObjectData>();
        state = LoadingState.FINISHED;
    }

    public function registerObject(scope:String, type:String, name:String, identifier:Int) {
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

    public function requestIdentifier(type:String, name:Dynamic, meta:String, callback:Int->Void) {
        var pair = (name:String).split(':'); // remoteScope:name
        if (pair.length == 1) {
            pair.unshift("");
        }

        requestIdentifierByObjectCallback(new ObjectCallback(meta, pair[0], type, pair[1], callback, false));
    }

    public function requestIdentifierByObjectCallback(callback:ObjectCallback) {
        checkIdentifier(callback.type);
        checkIdentifier(callback.name);

        if(callback.localScope == null) {
            trace('Error!');
        }

        if (state != FINISHED) {// enqueue request if loading is still in progress
            scheduledRequests.push(callback);
        } else {// execute immediately for "late" requests
            resolveIdentifier(callback);
        }
    }

    public function checkIdentifier(ID:String) {
        if (ID.charAt(ID.length - 1) == ".") {
            trace("BIG WARNING: identifier %s seems to be broken!", ID);
        } else {
            if (ID.toLowerCase() != ID) {
                trace("Warning: identifier %s is not in camelCase!", ID);
                ID = ID.toLowerCase();// Try to fix the ID
            }
        }
    }

    public function resolveIdentifier(request:ObjectCallback) {
        var identifiers = getPossibleIdentifiers(request);
        if (identifiers.length == 1) { // normally resolved ID
            request.callback(identifiers[0].id);
            return true;
        }

        if (request.optional && identifiers.length == 0) { // failed to resolve optinal ID
            return true;
        }

        // error found. Try to generate some debug info
        if (identifiers.length == 0) {
            trace('Unknown identifier! [${request.type}.${request.name}]');
        } else {
            trace("Ambiguous identifier request!");
        }

        trace('Request for ${request.type}. ${request.name} from mod ${request.localScope}');

        for (id in identifiers) {
            trace("\tID is available in mod %s", id.scope);
        }
        return false;
    }

    public function getPossibleIdentifiers(request:ObjectCallback):Array<ObjectData> {
        var allowedScopes:Array<String> = [];

        if (request.remoteScope == "") {
            // normally ID's from all required mods, own mod and virtual "core" mod are allowed
            if (request.localScope != "core" && request.localScope != "")
                allowedScopes = VLC.instance.modh.getModData(request.localScope).dependencies;

            if (allowedScopes.indexOf(request.localScope) == -1) allowedScopes.push(request.localScope);
            if (allowedScopes.indexOf("core") == -1) allowedScopes.push("core");
        } else {
            //...unless destination mod was specified explicitly
            //note: getModData does not work for "core" by design

            //for map format support core mod has access to any mod
            //TODO: better solution for access from map?
            if(request.localScope == "core" || request.localScope == "") {
                if (allowedScopes.indexOf(request.remoteScope) == -1) allowedScopes.push(request.remoteScope);
            } else {
                // allow only available to all core mod or dependencies
                var myDeps = VLC.instance.modh.getModData(request.localScope).dependencies;
                if(request.remoteScope == "core" || request.remoteScope == request.localScope || (myDeps.indexOf(request.remoteScope) > -1)) {
                    if (allowedScopes.indexOf(request.remoteScope) == -1) allowedScopes.push(request.remoteScope);
                }
            }
        }

        var fullID:String = request.type + '.' + request.name;

        var entry = registeredObjects.get(fullID);
        if (entry != null) {
            var locatedIDs:Array<ObjectData> = [];

            if (allowedScopes.indexOf(entry.scope) > -1) {
                locatedIDs.push(entry);
            }
            return locatedIDs;
        }
        return [];
    }
}

@:enum abstract LoadingState(Int) from Int to Int {
    public var LOADING:Int = 0;
    public var FINALIZING:Int = 1;
    public var FINISHED:Int = 2;
}