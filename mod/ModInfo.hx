package lib.mod;

import haxe.Json;
import data.ModData;

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
        for (keyName in ModData.data.keys()) {
            var configStr = ModData.data.get(keyName);
            try {
                config.set(keyName, Json.parse(configStr));
            }
            catch(e:Dynamic) {
                trace(keyName);
            }
        }
    }
}
