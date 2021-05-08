package mapping.campaign;

class CampaignState {
    public var camp:Campaign;
    public var campaignName:String;
    public var mapsConquered:Array<Int>;
    public var mapsRemaining:Array<Int>;
    public var currentMap:Int;

    public var chosenCampaignBonuses:Map<Int, Int>;

    public function new() {

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