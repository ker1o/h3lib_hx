package lib.mapping;

import lib.mapping.EventEffect.EventEffectType;
import lib.constants.id.PlayerColor;

class MapHeader {

    static var MAP_SIZE_SMALL:Int = 36;
    static var MAP_SIZE_MIDDLE:Int = 72;
    static var MAP_SIZE_LARGE:Int = 108;
    static var MAP_SIZE_XLARGE:Int = 144;

    public var version:MapFormat;
    public var height:Int;
    public var width:Int;
    public var twoLevel:Bool;
    public var name:String;
    public var description:String;
    public var difficulty:Int;
    public var levelLimit:Int;

    public var victoryMessage:String;
    public var defeatMessage:String;
    public var victoryIconIndex:Int;
    public var defeatIconIndex:Int;

    public var players:Array<PlayerInfo>;
    public var howManyTeams:Int;
    public var allowedHeroes:Array<Bool>;

    public var areAnyPlayers:Bool;

    public var triggeredEvents:Array<TriggeredEvent>;

    public function new() {
        setupEvents();

        players = new Array<PlayerInfo>();
        for (i in 0...PlayerColor.PLAYER_LIMIT) {
            players[i] = new PlayerInfo();
        }
    }

    //ToDo: implement EventExpression and set win/defeat triggers
    private function setupEvents() {
        triggeredEvents = [];

        var victoryCondition = new EventCondition(WinLoseType.STANDARD_WIN);
        var defeatCondition = new EventCondition(WinLoseType.DAYS_WITHOUT_TOWN);
        defeatCondition.value = 7;

        //Victory condition - defeat all
        var standardVictory = new TriggeredEvent();
        standardVictory.effect.type = EventEffectType.VICTORY;
        standardVictory.effect.toOtherMessage = "TBD: standardVictory.effect.toOtherMessage"; //VLC->generaltexth->allTexts[5]
        standardVictory.identifier = "standardVictory";
        standardVictory.description = ""; // TODO: display in quest window
        standardVictory.onFulfill = "TBD: standardVictory.onFulfill"; //VLC->generaltexth->allTexts[659];
//        standardVictory.trigger = new EventExpression(victoryCondition);

        //Loss condition - 7 days without town
        var standardDefeat = new TriggeredEvent();
        standardDefeat.effect.type = EventEffectType.DEFEAT;
        standardDefeat.effect.toOtherMessage = "standardDefeat.effect.toOtherMessage"; //VLC->generaltexth->allTexts[8];
        standardDefeat.identifier = "standardDefeat";
        standardDefeat.description = ""; // TODO: display in quest window
        standardDefeat.onFulfill = "TBD: standardDefeat.onFulfill"; //VLC->generaltexth->allTexts[7];
//        standardDefeat.trigger = new EventExpression(defeatCondition);

        triggeredEvents.push(standardVictory);
        triggeredEvents.push(standardDefeat);

        victoryIconIndex = 11;
        victoryMessage = "TBD: victoryMessage"; //VLC->generaltexth->victoryConditions[0];

        defeatIconIndex = 3;
        defeatMessage = "TBD: defeatMessage"; //VLC->generaltexth->lossCondtions[0];
    }
}
