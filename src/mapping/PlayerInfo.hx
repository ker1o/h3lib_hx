package mapping;

import utils.Int3;
import constants.AiTactic;

class PlayerInfo {

    public var canHumanPlay:Bool;
    public var canComputerPlay:Bool;
    public var aiTactic:AiTactic; // The default value is EAiTactic::RANDOM.

    public var allowedFactions:Array<Int>;
    public var isFactionRandom:Bool;
    public var hasRandomHero:Bool;

    // The default value is -1.
    public var mainCustomHeroPortrait:Int;
    public var mainCustomHeroName:String;

    // ID of custom lib.hero (only if portrait and lib.hero name are set, otherwise unpredicted value), -1 if none (not always -1)
    public var mainCustomHeroId:Int;

    public var heroesNames:Array<HeroName>; // list of placed heroes on the map
    public var hasMainTown:Bool; // The default value is false.
    public var generateHeroAtMainTown:Bool; // The default value is false.
    public var posOfMainTown:Int3;
    public var team:TeamID; /// The default value NO_TEAM


    public var generateHero:Bool; /// Unused.
    public var p7:Int; /// Unknown and unused.
    /// Unused. Count of lib.hero placeholders containing lib.hero type.
    /// WARNING: powerPlaceholders sometimes gives false 0 (eg. even if there is one placeholder), maybe different meaning ???
    public var powerPlaceholders:Int;

    public function new() {
        // ToDo: initialize some default as in VCMI
        allowedFactions = [];
        posOfMainTown = new Int3();
        heroesNames = [];
        team = new TeamID(0);
    }

    public function canAnyonePlay() {
        return canHumanPlay || canComputerPlay;
    }
}
