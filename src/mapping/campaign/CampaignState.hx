package mapping.campaign;

import constants.Obj;
import mapObjects.hero.GHeroInstance;

using Reflect;

class CampaignState {
    public var camp:Campaign;
    public var campaignName:String;
    public var mapsConquered:Array<Int>;
    public var mapsRemaining:Array<Int>;
    public var currentMap:Int;

    public var chosenCampaignBonuses:Map<Int, Int>;

    public function new() {

    }

    public static function crossoverDeserialize(jsonNode:Dynamic):GHeroInstance {
        var hero = new GHeroInstance();
        hero.ID = Obj.HERO;
        // deserialize?
//        hero.serializeJsonOptions(jsonNode);
        return hero;
    }

    public function getBonusForCurrentMap():TravelBonus {
        var bonuses = getCurrentScenario().travelOptions.bonusesToChoose;

        if (bonuses.length == 0) {
            return null;
        } else {
            return bonuses[currentBonusID()];
        }
    }

    function getCurrentScenario():CampaignScenario {
        return camp.scenarios[currentMap];
    }

    function currentBonusID() {
        return chosenCampaignBonuses[currentMap];
    }
}