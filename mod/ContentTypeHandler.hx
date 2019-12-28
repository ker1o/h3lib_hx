package lib.mod;

import utils.JsonUtils;

using Reflect;

private typedef ModInfo = {
    /// mod data from this mod and for this mod
    var modData:Dynamic;
    /// mod data for this mod from other mods (patches)
    var patches:Dynamic;
}

class ContentTypeHandler {
    /// handler to which all data will be loaded
    public var handler:IHandlerBase;
    public var objectName:String;

    /// contains all loaded H3 data
    public var originalData:Array<Dynamic>;
    public var modData:Map<String, ModInfo>;

    public function new(handler:IHandlerBase, objectName:String) {
        this.handler = handler;
        this.objectName = objectName;
        originalData = handler.loadLegacyData(VLC.instance.modh.settings.data.get(objectName));
        modData = new Map<String, ModInfo>();

        //set meta core?
    }

    public function preloadModData(modName:String, data:Dynamic, validate:Bool = false):Bool {
        var result:Bool = true;
        //data.setMeta(modName);

        var modInfo:ModInfo = {modData:{}, patches:{}};
        modData.set(modName, modInfo);

        for(fieldName in data.fields()) {
            var entry:Dynamic = data.field(fieldName);
            var colon = fieldName.indexOf(':');

//            if (colon == -1) {
                // normal object, local to this mod
                // swap modInfo.modData and entry
                modInfo.modData.setField(fieldName, entry);
//            } else {
//                var remoteName:String = fieldName.substr(0, colon);
//                var objectName:String = fieldName.substr(colon + 1);
//
//                // patching this mod? Send warning and continue - this situation can be handled normally
//                if (remoteName == modName) {
//                    trace("Redundant namespace definition for %s", objectName);
//                }
//
//                trace("Patching object %s (%s) from %s", objectName, remoteName, modName);
//                var remoteModInfo:ModInfo = modData.exists(remoteName) ? modData.get(remoteName) : new ModInfo();
//                if(remoteModInfo.patches == null) {
//                    remoteModInfo.patches = {};
//                }
//                var pathesObj = remoteModInfo.patches;
//
//                trace("WARNING!");
//                JsonUtils.merge(pathesObj, objectName, entry);
//            }
        }
        return result;
    }

    public function loadMod(modName:String, validate:Bool):Bool {
        var modInfo:ModInfo = modData[modName];
        var result:Bool = true;

        var performValidate = function(data:Dynamic, name:String) {
//            handler.beforeValidate(data);
//		    if (validate) { result = JsonUtils.validate(data, "vcmi:" + objectName, name) && result; }
        };

        // apply patches
//	    if (modInfo.patches != null) { JsonUtils.merge(modInfo.modData, modInfo.patches); }

        for (name in modInfo.modData.fields()) {
            var data:Dynamic = modInfo.modData.field(name);

            if (data.hasField("index")) {
                // try to add H3 object data
                var index = (data.field("index"):Int);

                if(originalData.length > index) {
//                    trace('found original data in loadMod($name) at index $index');
                    JsonUtils.merge(originalData, Std.string(index), data);
                    data = originalData[index];
                    originalData[index] = null; // do not use same data twice (same ID)
                } else {
//                    trace('no original data in loadMod($name) at index $index');
                }
                performValidate(data, name);
                handler.loadObject(modName, name, data, index);
            } else {
                // normal new object
                trace('no index in loadMod($name)');
                performValidate(data, name);
                handler.loadObject(modName, name, data);
            }
            modInfo.modData.setField(name, data);
        }
        return result;
    }
}
