package lib.mod;

class IHandlerBase {
    public function new() {
    }

    /// loads all original game data in vector of json nodes
    /// dataSize - is number of items that must be loaded (normally - constant from GameConstants)
    public function loadLegacyData(dataSize:Int):Array<Dynamic> {
        throw "IHandlerBase.loadLegacyData(): needs override";
    }
}
