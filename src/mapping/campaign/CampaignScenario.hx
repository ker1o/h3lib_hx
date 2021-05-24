package mapping.campaign;

import mapObjects.hero.GHeroInstance;
import constants.id.HeroTypeId;

using Lambda;

class CampaignScenario {
    public var mapName:String; //*.h3m
    public var scenarioName:String; //from header. human-readble
    public var packedMapSize:Int; //generally not used
    public var preconditionRegions:Array<Int>; //what we need to conquer to conquer this one (stored as bitfield in h3c)
    public var regionColor:Int;
    public var difficulty:Int;
    public var conquered:Bool;

    public var regionText:String;
//    public var epilog:ScenarioPrologEpilog;
//    public var prolog:ScenarioPrologEpilog;

    public var travelOptions:ScenarioTravel;
    public var keepHeroes:Array<HeroTypeId>; // contains list of heroes which should be kept for next scenario (doesn't matter if they lost)
    public var crossoverHeroes:Array<Dynamic>; // contains all heroes with the same state when the campaign scenario was finished
    public var placedCrossoverHeroes:Array<Dynamic>; // contains all placed crossover heroes defined by hero placeholders when the scenario was started
    
    public function new() {
    }

    public function getLostCrossoverHeroes() {
        var lostCrossoverHeroes:Array<GHeroInstance> = [];
        if (conquered) {
            for (node2 in placedCrossoverHeroes) {
                var hero = CampaignState.crossoverDeserialize(node2);
                var exists = crossoverHeroes.exists(function(node) {
                    var h = CampaignState.crossoverDeserialize(node);
                    var result = hero.subID == h.subID;
                    return result;
                });
                if (exists) {
                    lostCrossoverHeroes.push(hero);
                }
            }
        }
        return lostCrossoverHeroes;
    }
}