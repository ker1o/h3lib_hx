package gamestate;

import gamestatefwd.InfoAboutHero;
import constants.AiTactic;
import constants.id.PlayerColor;

class ThievesGuildInfo {
    public var playerColors:Array<PlayerColor>; //colors of players that are in-game

    // [place] -> [colours of players]
    public var numOfTowns:Array<Array<PlayerColor>>;
    public var numOfHeroes:Array<Array<PlayerColor>>;
    public var gold:Array<Array<PlayerColor>>;
    public var woodOre:Array<Array<PlayerColor>>;
    public var mercSulfCrystGems:Array<Array<PlayerColor>>;
    public var obelisks:Array<Array<PlayerColor>>;
    public var artifacts:Array<Array<PlayerColor>>;
    public var army:Array<Array<PlayerColor>>;
    public var income:Array<Array<PlayerColor>>;

    public var colorToBestHero:Map<PlayerColor, InfoAboutHero>; //maps player's color to his best heros'

    public var personality:Map<PlayerColor, AiTactic>; // color to personality // ai tactic
    public var bestCreature:Map<PlayerColor, Int>; // color to ID // id or -1 if not known

    public function new() {

    }
}