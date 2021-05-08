package gamestate;

import playerstate.PlayerState;
import constants.id.PlayerColor;
import battle.BattleInfo;
import mapping.TeamID;
import playerstate.TeamState;
import herobonus.BonusSystemNode;
import mapping.IMapService;
import mapping.MapBody;
import startinfo.StartInfo;

class GameState {
    public var scenarioOps:StartInfo;
    public var currentPlayer:PlayerColor; //ID of player currently having turn
    public var curB:BattleInfo; //current battle
    public var day:Int; //total number of days in game
    public var map:MapBody;
    public var players:Map<PlayerColor, PlayerState>;
    public var teams:Map<TeamID, TeamState>;
    public var globalEffects:BonusSystemNode;
//    public var rumor:RumorState;

    public function new() {
        scenarioOps = new StartInfo();

    }

    public function init(mapService:IMapService, startInfo:StartInfo = null, allowSavingRandomMap:Bool = false) {
        //ToDo
        initNewGame(mapService, "Vial of Life.h3m");

        trace("initialization");
        initPlayerStates();
        placeCampaignHeroes();
        initGrailPosition();
        initRandomFactionsForPlayers();
        randomizeMapObjects();
        placeStartingHeroes();
        initStartingResources();
        initHeroes();
        initStartingBonus();
        initTowns();
        initMapObjects();
        buildBonusSystemTree();
        initVisitingAndGarrisonedHeroes();
        initFogOfWar();
    }

    private function initNewGame(mapService:IMapService, mapName:String) {
        mapService.loadMapHeaderByName(mapName);
        map = mapService.loadMapByName(mapName);
    }

    function initPlayerStates() {
        trace("Creating player entries in gs");
        for(elemKey in scenarioOps.playerInfos.keys())
        {
            var p = players[elemKey];
            p.color = elemKey;
            p.human = scenarioOps.playerInfos[elemKey].isControlledByHuman();
            p.team = map.players[elemKey.getNum()].team;
            teams[p.team].id = p.team;//init team
            teams[p.team].players.insert(elemKey);//add player to team
        }
    }

    function placeCampaignHeroes() {
    }

    function initGrailPosition() {
    }

    function initRandomFactionsForPlayers() {
    }

    function randomizeMapObjects() {
    }

    function placeStartingHeroes() {
    }

    function initStartingResources() {
    }

    function initHeroes() {
    }

    function initStartingBonus() {
    }

    function initTowns() {
    }

    function initMapObjects() {
    }

    function buildBonusSystemTree() {
    }

    function initVisitingAndGarrisonedHeroes() {
    }

    function initFogOfWar() {
    }

}