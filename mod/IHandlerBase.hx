package lib.mod;

interface IHandlerBase {
    /// loads all original game data in vector of json nodes
    /// dataSize - is number of items that must be loaded (normally - constant from GameConstants)
    function loadLegacyData(dataSize:Int):Array<Dynamic>;

    /// loads single object into game. Scope is namespace of this object, same as name of source mod
    function loadObject(scope:String, name:String, data:Dynamic, index:UInt = 0):Void;
}
