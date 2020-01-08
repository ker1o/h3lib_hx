package lib.constants;

@:enum abstract BuildingID(Int) from Int to Int {
    //Quite useful as long as most of building mechanics hardcoded
    // NOTE: all building with completely configurable mechanics will be removed from list
    public static inline var DEFAULT:Int = -50;
    public static inline var NONE = -1;
    public static inline var MAGES_GUILD_1 = 0;
    public static inline var MAGES_GUILD_2 = 1;
    public static inline var MAGES_GUILD_3 = 2;
    public static inline var MAGES_GUILD_4 = 3;
    public static inline var MAGES_GUILD_5 = 4;
    public static inline var TAVERN = 5;
    public static inline var SHIPYARD = 6;
    public static inline var FORT = 7;
    public static inline var CITADEL = 8;
    public static inline var CASTLE = 9;
    public static inline var VILLAGE_HALL = 10;
    public static inline var TOWN_HALL = 11;
    public static inline var CITY_HALL = 12;
    public static inline var CAPITOL = 13;
    public static inline var MARKETPLACE = 14;
    public static inline var RESOURCE_SILO = 15;
    public static inline var BLACKSMITH = 16;
    public static inline var SPECIAL_1 = 17;
    public static inline var HORDE_1 = 18;
    public static inline var HORDE_1_UPGR = 19;
    public static inline var SHIP = 20;
    public static inline var SPECIAL_2 = 21;
    public static inline var SPECIAL_3 = 22;
    public static inline var SPECIAL_4 = 23;
    public static inline var HORDE_2 = 24;
    public static inline var HORDE_2_UPGR = 25;
    public static inline var GRAIL = 26;
    public static inline var EXTRA_TOWN_HALL = 27;
    public static inline var EXTRA_CITY_HALL = 28;
    public static inline var EXTRA_CAPITOL = 29;
    public static inline var DWELL_FIRST = 30;
    public static inline var DWELL_LVL_2 = 31;
    public static inline var DWELL_LVL_3 = 32;
    public static inline var DWELL_LVL_4 = 33;
    public static inline var DWELL_LVL_5 = 34;
    public static inline var DWELL_LVL_6 = 35;
    public static inline var DWELL_LAST= 36;
    public static inline var DWELL_UP_FIRST = 37;
    public static inline var DWELL_LVL_2_UP = 38;
    public static inline var DWELL_LVL_3_UP = 39;
    public static inline var DWELL_LVL_4_UP = 40;
    public static inline var DWELL_LVL_5_UP = 41;
    public static inline var DWELL_LVL_6_UP = 42;
    public static inline var DWELL_UP_LAST = 43;

    public static inline var DWELL_LVL_1 = DWELL_FIRST;
    public static inline var DWELL_LVL_7 = DWELL_LAST;
    public static inline var DWELL_LVL_1_UP = DWELL_UP_FIRST;
    public static inline var DWELL_LVL_7_UP = DWELL_UP_LAST;

    //Special buildings for towns.
    public static inline var LIGHTHOUSE  = SPECIAL_1;
    public static inline var STABLES     = SPECIAL_2; //Castle
    public static inline var BROTHERHOOD = SPECIAL_3;

    public static inline var MYSTIC_POND         = SPECIAL_1;
    public static inline var FOUNTAIN_OF_FORTUNE = SPECIAL_2; //Rampart
    public static inline var TREASURY            = SPECIAL_3;

    public static inline var ARTIFACT_MERCHANT = SPECIAL_1;
    public static inline var LOOKOUT_TOWER     = SPECIAL_2; //Tower
    public static inline var LIBRARY           = SPECIAL_3;
    public static inline var WALL_OF_KNOWLEDGE = SPECIAL_4;

    public static inline var STORMCLOUDS   = SPECIAL_2;
    public static inline var CASTLE_GATE   = SPECIAL_3; //Inferno
    public static inline var ORDER_OF_FIRE = SPECIAL_4;

    public static inline var COVER_OF_DARKNESS    = SPECIAL_1;
    public static inline var NECROMANCY_AMPLIFIER = SPECIAL_2; //Necropolis
    public static inline var SKELETON_TRANSFORMER = SPECIAL_3;

    //ARTIFACT_MERCHANT - same ID as in tower
    public static inline var MANA_VORTEX      = SPECIAL_2;
    public static inline var PORTAL_OF_SUMMON = SPECIAL_3; //Dungeon
    public static inline var BATTLE_ACADEMY   = SPECIAL_4;

    public static inline var ESCAPE_TUNNEL     = SPECIAL_1;
    public static inline var FREELANCERS_GUILD = SPECIAL_2; //Stronghold
    public static inline var BALLISTA_YARD     = SPECIAL_3;
    public static inline var HALL_OF_VALHALLA  = SPECIAL_4;

    public static inline var CAGE_OF_WARLORDS = SPECIAL_1;
    public static inline var GLYPHS_OF_FEAR   = SPECIAL_2; // Fortress
    public static inline var BLOOD_OBELISK    = SPECIAL_3;

    //ARTIFACT_MERCHANT - same ID as in tower
    public static inline var MAGIC_UNIVERSITY = SPECIAL_2; // Conflux

}
