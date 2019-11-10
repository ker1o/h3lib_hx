package lib.mod;

interface IHandlerBase {
    /// loads all original game data in vector of json nodes
    /// dataSize - is number of items that must be loaded (normally - constant from GameConstants)
    function loadLegacyData(dataSize:Int):Array<Dynamic>;
}
