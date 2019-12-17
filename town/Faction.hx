
package lib.town;
import mapping.TerrainType;
import constants.Alignment;
class Faction {
    public var name:String; //town name, by default - from TownName.txt
    public var identifier:String;

    public var index:Int;

    public var nativeTerrain:TerrainType;
    public var alignment:Alignment;

    public var town:Town; //NOTE: can be null

    public var creatureBg120:String;
    public var creatureBg130:String;

    public function new() {
    }
}
