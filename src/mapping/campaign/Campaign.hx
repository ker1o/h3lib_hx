package mapping.campaign;

class Campaign {
    public var header:CampaignHeader;
    public var scenarios:Array<CampaignScenario>;
    public var mapPieces:Map<Int, String>; //binary h3ms, scenario number -> map data

    public function new() {
    }
}