package lib.mod;

import filesystem.FileCache;
import haxe.Json;

using Reflect;

class ModInfo {
    /// identifier, identical to name of folder with mod
    public var identifier:String;

    /// human-readable strings
    public var name:String;
    public var description:String;

    /// list of mods that should be loaded before this one
    public var dependencies:Array<String>;

    /// list of mods that can't be used in the same time as this one
    public var conflicts:Array<String>;

    /// CRC-32 checksum of the mod
    public var checksum:UInt;

    /// true if mod is enabled
    public var enabled:Bool;

    public var config:Map<String, Dynamic>;

    public function new(identifier:String, local:Dynamic) {
        this.identifier = identifier;

        //Not presented in the original
        config = new Map<String, Dynamic>();
        var modData:Dynamic = FileCache.instance.getConfig("mod");
        for (keyName in modData.fields()) {
            var configData = modData.field(keyName);
            try {
                config.set(keyName, configData);
            }
            catch(e:Dynamic) {
                trace('Error loading mod data for $keyName');
            }
        }
    }
}
