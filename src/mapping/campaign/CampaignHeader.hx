package mapping.campaign;

class CampaignHeader {
    public var version:Int; //4 - RoE, 5 - AB, 6 - SoD and WoG
    public var mapVersion:Int; //CampText.txt's format
    public var description:String;
    public var name:String;
    public var difficultyChoosenByPlayer:Int;
    public var music:Int; //CmpMusic.txt, start from 0

    public var filename:String;
    public var loadFromLod:Int; //if true, this campaign must be loaded fro, .lod file

    public function new() {

    }
}