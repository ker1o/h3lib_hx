package lib.mod;

typedef ModInfo = {
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
    var originalData:Array<Dynamic>;
    var modData:Map<String, ModInfo>;

    public function new(handler:IHandlerBase, objectName:String) {
        this.handler = handler;
        this.objectName = objectName;
        originalData = handler.loadLegacyData(VLC.instance.modh.settings.data.get(objectName));
    }
}
