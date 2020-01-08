package mod;

using Reflect;

class ModHandler {
    public var identifiers:IdentifierStorage;
    public var content:ContentHandler;

    public var settings:HardcodedFeatures;
    public var modules: {
        STACK_EXP:Bool,
        STACK_ARTIFACT:Bool,
        COMMANDERS:Bool,
        MITHRIL:Bool
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

    public function loadMods() {
        var modConfig:Dynamic = {core: {}};

        coreMod = new ModInfo("core", modConfig.field("core"));
        coreMod.name = "Original game files";
    }

    public function load() {
        content.init();

        // first - load virtual "core" mod that contains all data
        // TODO? move all data into real mods? RoE, AB, SoD, WoG
        content.preloadData(coreMod);

        content.load(coreMod);

        identifiers.finalize();
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

        if(mod == null) {
            throw 'Mod not found "$modId"';
        } else {
            return mod;
        }
    }

    public static function makeFullIdentifier(scope:String, type:String, identifier:String) {
        if(type == "") {
            trace('Full identifier ($scope $identifier) requires type name');
        }

        var actualScope = scope;
        var actualName = identifier;

            //ignore scope if identifier is scoped
        var scopeAndName = identifier.split(':');
        if (scopeAndName.length == 1) {
            scopeAndName.unshift("");
        }

        if(scopeAndName[0] != "") {
            actualScope = scopeAndName[0];
            actualName = scopeAndName[1];
        }

        if(actualScope == "") {
            return actualName == "" ? type : type + "." + actualName;
        } else {
            return actualName == "" ? actualScope+ ":" + type : actualScope + ":" + type + "." + actualName;
        }
    }
}
