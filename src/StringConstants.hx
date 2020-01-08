package;

class StringConstants {
    // GameConstants
    public static var TERRAIN_NAMES = ["dirt", "sand", "grass", "snow", "swamp", "rough", "subterra", "lava", "water", "rock"];
    public static var RESOURCE_NAMES = ["wood", "mercury", "ore", "sulfur", "crystal", "gems", "gold", "mithril"];
    public static var PLAYER_COLOR_NAMES = ["red", "blue", "tan", "green", "orange", "purple", "teal", "pink"];

    public static var PRIMARY_SKILLS = ["attack", "defence", "spellpower", "knowledge"];
    public static var SECONDARY_SKILLS_NAMES = [
        "pathfinding",  "archery",      "logistics",    "scouting",     "diplomacy",    //  5
        "navigation",   "leadership",   "wisdom",       "mysticism",    "luck",         // 10
        "ballistics",   "eagleEye",     "necromancy",   "estates",      "fireMagic",    // 15
        "airMagic",     "waterMagic",   "earthMagic",   "scholar",      "tactics",      // 20
        "artillery",    "learning",     "offence",      "armorer",      "intelligence", // 25
        "sorcery",      "resistance",   "firstAid"
    ];
    public static var SECONDARY_SKILLS_LEVELS = ["none", "basic", "advanced", "expert"];

    public static var TOWN_TYPE = [
        "castle",       "rampart",      "tower",
        "inferno",      "necropolis",   "dungeon",
        "stronghold",   "fortress",     "conflux"
    ];

    public static var BUILDING_TYPE = [
        "mageGuild1",       "mageGuild2",       "mageGuild3",       "mageGuild4",       "mageGuild5",
        "tavern",           "shipyard",         "fort",             "citadel",          "castle",
        "villageHall",      "townHall",         "cityHall",         "capitol",          "marketplace",
        "resourceSilo",     "blacksmith",       "special1",         "horde1",           "horde1Upgr",
        "ship",             "special2",         "special3",         "special4",         "horde2",
        "horde2Upgr",       "grail",            "extraTownHall",    "extraCityHall",    "extraCapitol",
        "dwellingLvl1",     "dwellingLvl2",     "dwellingLvl3",     "dwellingLvl4",     "dwellingLvl5",
        "dwellingLvl6",     "dwellingLvl7",     "dwellingUpLvl1",   "dwellingUpLvl2",   "dwellingUpLvl3",
        "dwellingUpLvl4",   "dwellingUpLvl5",   "dwellingUpLvl6",   "dwellingUpLvl7"
    ];
}
