package lib.mod;

class ModHandler {
    public var identifiers:IdentifierStorage;
    public var content:ContentHandler;

    public var settings:HardcodedFeatures;
    public var modules: {
        var STACK_EXP:Bool;
        var STACK_ARTIFACT:Bool;
        var COMMANDERS:Bool;
        var MITHRIL:Bool;
    };

    private var allMods:Map<String, ModInfo>;
    private var activeMods:Array<String>;//active mods, in order in which they were loaded
    private var coreMod:ModInfo;

    public function new() {
        settings = new HardcodedFeatures();
        modules = {
            STACK_EXP: false,
            STACK_ARTIFACT: false,
            COMMANDERS: false,
            MITHRIL: false //so far unused
        };

        content = new ContentHandler();
        identifiers = new IdentifierStorage();

        allMods = new Map<String, ModInfo>();
        activeMods = [];
    }

    public function load() {
        content.init();
    }

    public static function normalizeIdentifier(scope:String, remoteScope:String, identifier:String):String {
        var p:{first:String, second:String};
        var arr = identifier.split(':');
        if(arr.length == 1) {
            p = {first:null, second:arr[0]};
        } else {
            p = {first:arr.shift(), second:arr.join(':')}
        }

        if(p.first == null)
            p.first = scope;

        if(p.first == remoteScope)
            p.first = null;

        return p.first == null ? p.second : p.first + ":" + p.second;
    }

    public inline function getModData(modId:String):ModInfo {
        var mod = allMods.get(modId);

        if(mod == null)
        {
            throw 'Mod not found "$modId"';
        } else {
            return mod;
        }
    }
}
