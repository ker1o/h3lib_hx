package text;

class GeneralTextHandler {
    public var localizedTexts:Dynamic;

    public var allTexts:Array<String>;

    public var arraytxt:Array<String>;
    public var primarySkillNames:Array<String>;
    public var jktexts:Array<String>;
    public var heroscrn:Array<String>;
    public var overview:Array<String>;//text for Kingdom Overview window
    public var colors:Array<String>; //names of player colors ("red",...)
    public var capColors:Array<String>; //names of player colors with first letter capitalized ("Red",...)
    public var turnDurations:Array<String>; //turn durations for pregame (1 Minute ... Unlimited)

    //towns
    public var tcommands:Array<String>; //texts for town screen
    public var hcommands:Array<String>; //texts for town hall screen
    public var fcommands:Array<String>; //texts for fort screen
    public var tavernInfo:Array<String>;
    public var tavernRumors:Array<String>;

    public var zelp:Array<{k:String, v:String}>;
    public var lossCondtions:Array<String>;
    public var victoryConditions:Array<String>;

    //objects
    public var creGens:Array<String>; //names of creatures' generators
    public var creGens4:Array<String>; //names of multiple creatures' generators
    public var advobtxt:Array<String>;
    public var xtrainfo:Array<String>;
    public var restypes:Array<String>; //names of resources
    public var terrainNames:Array<String>;
    public var randsign:Array<String>;
    public var mines:Array<{name:String, description:String}>; //first - name; second - event description
    public var seerEmpty:Array<String>;
    public var quests:Array<Array<Array<String>>> ; //[quest][type][index]
    //type: quest, progress, complete, rollover, log OR time limit //index: 0-2 seer hut, 3-5 border guard
    public var seerNames:Array<String>;
    public var tentColors:Array<String>;

    //sec skills
    public var levels:Array<String>;
    public var zcrexp:Array<String>; //more or less useful content of that file
    //commanders
    public var znpc00:Array<String>; //more or less useful content of that file

    //campaigns
    public var campaignMapNames:Array<String>;
    public var campaignRegionNames:Array<Array<String>>;

    public function new() {
        allTexts = [for(i in 0...1000) ""];

        readToVector("DATA/VCDESC.TXT",   victoryConditions = []);
        readToVector("DATA/LCDESC.TXT",   lossCondtions = []);
        readToVector("DATA/TCOMMAND.TXT", tcommands = []);
        readToVector("DATA/HALLINFO.TXT", hcommands = []);
        readToVector("DATA/CASTINFO.TXT", fcommands = []);
        readToVector("DATA/ADVEVENT.TXT", advobtxt = []);
        readToVector("DATA/XTRAINFO.TXT", xtrainfo = []);
        readToVector("DATA/RESTYPES.TXT", restypes = []);
        readToVector("DATA/TERRNAME.TXT", terrainNames = []);
        readToVector("DATA/RANDSIGN.TXT", randsign = []);
        readToVector("DATA/CRGEN1.TXT",   creGens = []);
        readToVector("DATA/CRGEN4.TXT",   creGens4 = []);
        readToVector("DATA/OVERVIEW.TXT", overview = []);
        readToVector("DATA/ARRAYTXT.TXT", arraytxt = []);
        readToVector("DATA/PRISKILL.TXT", primarySkillNames = []);
        readToVector("DATA/JKTEXT.TXT",   jktexts = []);
        readToVector("DATA/TVRNINFO.TXT", tavernInfo = []);
        readToVector("DATA/RANDTVRN.TXT", tavernRumors = []);
        readToVector("DATA/TURNDUR.TXT",  turnDurations = []);
        readToVector("DATA/HEROSCRN.TXT", heroscrn = []);
        readToVector("DATA/TENTCOLR.TXT", tentColors = []);
        readToVector("DATA/SKILLLEV.TXT", levels = []);

        //ToDo
    }

    public function readToVector(sourceName:String, dest:Array<String>) {
        //ToDo

    }
}
