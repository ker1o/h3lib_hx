package constants;

class GameConstants {
    public static inline var MAX_HERO_LEVEL = 70; // 872895685	exp (limited by Int.MAX_VALUE)

    public static inline var PUZZLE_MAP_PIECES:Int = 48;

    public static inline var MAX_HEROES_PER_PLAYER:Int = 8;
    public static inline var AVAILABLE_HEROES_PER_PLAYER:Int = 2;

    public static inline var ALL_PLAYERS:Int = 255; //bitfield

    public static inline var BACKPACK_START:Int = 19;
    public static inline var CREATURES_PER_TOWN:Int = 7; //without upgrades
    public static inline var SPELL_LEVELS:Int = 5;
    public static inline var SPELL_SCHOOL_LEVELS:Int = 4;
    public static inline var CRE_LEVELS:Int = 10; // number of creature experience levels

    public static inline var HERO_GOLD_COST:Int = 2500;
    public static inline var SPELLBOOK_GOLD_COST:Int = 500;
    public static var SKILL_GOLD_COST:Int = 2000;
    public static var BATTLE_PENALTY_DISTANCE:Int = 10; //if the distance is > than this, then shooting stack has distance penalty
    public static var ARMY_SIZE:Int = 7;
    public static var SKILL_PER_HERO:Int = 8;

    public static var SKILL_QUANTITY:Int = 28;
    public static var PRIMARY_SKILLS:Int = 4;
    public static var TERRAIN_TYPES:Int = 10;
    public static var RESOURCE_QUANTITY:Int = 8;
    public static var HEROES_PER_TYPE:Int = 8; //amount of heroes of each type

    // amounts of OH3 objects. Can be changed by mods, should be used only during H3 loading phase
    public static var F_NUMBER:Int = 9;
    public static var ARTIFACTS_QUANTITY:Int = 171;
    public static var HEROES_QUANTITY:Int = 156;
    public static var SPELLS_QUANTITY:Int = 70;
    public static var CREATURES_COUNT:Int = 197;

    public static var BASE_MOVEMENT_COST:Int = 100; //default cost for non-diagonal movement

    public static var HERO_PORTRAIT_SHIFT:Int = 30;// 2 special frames + some extra portraits
}
