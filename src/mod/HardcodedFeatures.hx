package mod;

class HardcodedFeatures {

    public var data:Map<String, Int>;

    public var CREEP_SIZE:Int;
    public var WEEKLY_GROWTH:Int;
    public var NEUTRAL_STACK_EXP:Int;
    public var MAX_BUILDING_PER_TURN:Int;
    public var DWELLINGS_ACCUMULATE_CREATURES:Bool;
    public var ALL_CREATURES_GET_DOUBLE_MONTHS:Bool;
    public var NEGATIVE_LUCK:Bool;
    public var MAX_HEROES_AVAILABLE_PER_PLAYER:Int;
    public var MAX_HEROES_ON_MAP_PER_PLAYER:Int;
    public var WINNING_HERO_WITH_NO_TROOPS_RETREATS:Bool;
    public var BLACK_MARKET_MONTHLY_ARTIFACTS_CHANGE:Bool;

    public function new() {
        data = [
            "heroClass" => 18,
            "artifact" => 144,
            "creature" => 150,
            "faction" => 9,
            "hero" => 156,
            "spell" => 81,
            "object" => 256,
            "mapVersion" => 28,
        ];

        CREEP_SIZE = 4000;
        WEEKLY_GROWTH = 10; //percent
        NEUTRAL_STACK_EXP = 500; // daily
        MAX_BUILDING_PER_TURN = 1;
        DWELLINGS_ACCUMULATE_CREATURES = true;
        ALL_CREATURES_GET_DOUBLE_MONTHS = false;
        NEGATIVE_LUCK = false;
        MAX_HEROES_AVAILABLE_PER_PLAYER = 16;
        MAX_HEROES_ON_MAP_PER_PLAYER = 8;
        WINNING_HERO_WITH_NO_TROOPS_RETREATS = true;
        BLACK_MARKET_MONTHLY_ARTIFACTS_CHANGE = true;
    }
}
