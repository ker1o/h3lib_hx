package lib.town;

import constants.CreatureId;
import constants.BuildingID;
import constants.ArtifactId;

class Town {
    public var faction:Faction;

    public var names:Array<String>; //names of the town instances

    /// level -> list of creatures on this tier
    public var creatures:Array<Array<CreatureId>>;

    public var buildings:Map<BuildingID, Building>;

    public var dwellings:Array<String>; //defs for adventure map dwellings for new towns, [0] means tier 1 creatures etc.
    public var dwellingNames:Array<String>;

    // should be removed at least from configs in favor of auto-detection
    public var hordeLvl:Map<Int, Int>; //[0] - first horde building creature level. [1] - second horde building (-1 if not present)
    public var mageLevel:Int; //max available mage guild level
    public var primaryRes:Int;
    public var warMachine:ArtifactId;
    public var moatDamage:Int;
    public var moatHexes:Array<BattleHex>;
    // default chance for hero of specific class to appear in tavern, if field "tavern" was not set
    // resulting chance = sqrt(town.chance * heroClass.chance)
    public var defaultTavernChance:Int;

    public function new() {
    }
}
