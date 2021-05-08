package gamestate;

import mapping.campaign.CampaignState;
import mapObjects.town.GTownInstance;
import mapObjects.GObjectInstance;
import utils.Int3;
import battle.BattleInfo;
import constants.id.HeroTypeId;
import constants.id.PlayerColor;
import constants.Obj;
import herobonus.BonusSystemNode;
import mapObjects.hero.GHeroInstance;
import mapObjects.hero.GHeroPlaceholder;
import mapping.campaign.TravelBonusType;
import mapping.IMapService;
import mapping.MapBody;
import mapping.TeamID;
import mod.VLC;
import playerstate.PlayerState;
import playerstate.TeamState;
import startinfo.PlayerSettings;
import startinfo.PlayerSettingsBonus;
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
        if (scenarioOps.campState) {
            // place bonus hero
            var campaignBonus = scenarioOps.campState.getBonusForCurrentMap();
            var campaignGiveHero = campaignBonus && campaignBonus.type == TravelBonusType.HERO;

            if (campaignGiveHero) {
                var playerColor = new PlayerColor(campaignBonus.info1);
                var it = scenarioOps.playerInfos.get(playerColor);
                if (it != null) {
                    var heroTypeId = campaignBonus.info2;
                    if (heroTypeId == 0xffff) {// random bonus hero
                        heroTypeId = pickUnusedHeroTypeRandomly(playerColor);
                    }

                    placeStartingHero(playerColor, new HeroTypeId(heroTypeId), map.players[playerColor.getNum()].posOfMainTown);
                }
            }

            // replace heroes placeholders
            var crossoverHeroes = getCrossoverHeroesFromPreviousScenarios();

            if(!crossoverHeroes.heroesFromAnyPreviousScenarios.empty()) {
                trace("\tGenerate list of hero placeholders");
                var campaignHeroReplacements = generateCampaignHeroesToReplace(crossoverHeroes);

                trace("\tPrepare crossover heroes");
                prepareCrossoverHeroes(campaignHeroReplacements, scenarioOps.campState.getCurrentScenario().travelOptions);

                // remove same heroes on the map which will be added through crossover heroes
                // INFO: we will remove heroes because later it may be possible that the API doesn't allow having heroes
                // with the same hero type id
                var removedHeroes:Array<GHeroInstance>;

                for (campaignHeroReplacement in campaignHeroReplacements) {
                    var hero = getUsedHero(new HeroTypeId(campaignHeroReplacement.hero.subID));
                    if(hero) {
                        removedHeroes.push(hero);
                        map.heroesOnMap -= hero;
                        map.objects[hero.id.getNum()] = nullptr;
                        map.removeBlockVisTiles(hero, true);
                    }
                }

                trace("\tReplace placeholders with heroes");
                replaceHeroesPlaceholders(campaignHeroReplacements);

                // remove hero placeholders on map
                for(obj in map.objects) {
                    if(obj != null && obj.ID == Obj.HERO_PLACEHOLDER) {
                        var heroPlaceholder:GHeroPlaceholder = cast obj;
                        map.removeBlockVisTiles(heroPlaceholder, true);
                        map.instanceNames.erase(obj.instanceName);
                        map.objects.remove(heroPlaceholder.id.getNum());
                    }
                }

                // now add removed heroes again with unused type ID
                for(hero in removedHeroes) {
                    var heroTypeId = 0;
                    if(hero.ID == Obj.HERO) {
                        heroTypeId = pickUnusedHeroTypeRandomly(hero.tempOwner);
                    } else if(hero.ID == Obj.PRISON) {
                        var unusedHeroTypeIds = getUnusedAllowedHeroes();
                        if(!unusedHeroTypeIds.empty()) {
                            heroTypeId = (*RandomGeneratorUtil.nextItem(unusedHeroTypeIds, getRandomGenerator())).getNum();
                        } else {
                            trace("No free hero type ID found to replace prison.");
                        }
                    }

                    hero.subID = heroTypeId;
                    hero.portrait = hero.subID;
                    map.getEditManager().insertObject(hero);
                }
            }
        }
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

    function pickUnusedHeroTypeRandomly(owner:PlayerColor) {
        //list of available heroes for this faction and others
        var factionHeroes:Array<HeroTypeId> = [];
        var otherHeroes:Array<HeroTypeId> = [];

        var ps:PlayerSettings = scenarioOps.getIthPlayersSettings(owner);
        for(hid in getUnusedAllowedHeroes()) {
            if(VLC.instance.heroh.heroes[hid.getNum()].heroClass.faction == ps.castle) {
                factionHeroes.push(hid);
            } else {
                otherHeroes.push(hid);
            }

            // select random hero native to "our" faction
            if(!factionHeroes.empty()) {
                return RandomGeneratorUtil.nextItem(factionHeroes, getRandomGenerator()).getNum();
            }

            trace("Cannot find free hero of appropriate faction for player %s - trying to get first available...", owner.getStr());
            if(!otherHeroes.empty()) {
                return RandomGeneratorUtil.nextItem(otherHeroes, getRandomGenerator()).getNum();
            }

            trace("No free allowed heroes!");
            var notAllowedHeroesButStillBetterThanCrash = getUnusedAllowedHeroes(true);
            if (notAllowedHeroesButStillBetterThanCrash.size())
                return notAllowedHeroesButStillBetterThanCrash.begin().getNum();

            trace("No free heroes at all!");
            return -1; // no available heroes at all
        }
    }

    function getUnusedAllowedHeroes(alsoIncludeNotAllowed:Bool):Array<HeroTypeId> {
        var ret:Array<HeroTypeId> = [];
        for(i in 0...map.allowedHeroes.length) {
            if(map.allowedHeroes[i] || alsoIncludeNotAllowed) {
                ret.push(new HeroTypeId(i));
            }
        }

        for(playerInfo in scenarioOps.playerInfos) {//remove uninitialized yet heroes picked for start by other players
            if (playerInfo.hero != PlayerSettingsBonus.RANDOM) {
                ret.remove(new HeroTypeId(playerInfo.hero));
            }
        }

        for(hero in map.heroesOnMap) { //heroes instances initialization
            if (hero.type != null) {
                ret.remove(hero.type.ID);
            } else {
                ret.remove(new HeroTypeId(hero.subID));
            }
        }

        for(obj in map.objects) {//prisons
            if(obj != null && obj.ID == Obj.PRISON) {
                ret.remove(new HeroTypeId(obj.subID));
            }
        }

        return ret;
    }

    function placeStartingHero(playerColor:PlayerColor, heroTypeId:HeroTypeId, townPos:Int3) {
        townPos.x -= 2; //FIXME: use actual visitable offset of town

        var hero = createObject(Obj.HERO, heroTypeId.getNum(), townPos, playerColor);
        hero.pos += hero.getVisitableOffset();
        map.getEditManager().insertObject(hero);
    }

    static function createObject(id:Obj, subid:Int, pos:Int3, owner:PlayerColor):GObjectInstance {
        var nobj:GObjectInstance;
        switch(id) {
            case Obj.HERO:
                var handler = VLC.instance.objtypeh.getHandlerFor(id, VLC.instance.heroh.heroes[subid].heroClass.id);
                nobj = handler.create(handler.getTemplates()[0]);
            case Obj.TOWN:
                nobj = new GTownInstance();
            default: //rest of objects
                nobj = new GObjectInstance();
        }
        nobj.ID = id;
        nobj.subID = subid;
        nobj.pos = pos;
        nobj.tempOwner = owner;
        if (id != Obj.HERO) {
            nobj.appearance = VLC.instance.objtypeh.getHandlerFor(id, subid).getTemplates()[0];
        }

        return nobj;
    }

    function getCrossoverHeroesFromPreviousScenarios():CrossoverHeroesList {
        var crossoverHeroes:CrossoverHeroesList;

        var campaignState = scenarioOps.campState;
        var bonus = campaignState.getBonusForCurrentMap();
        if (bonus != null && bonus.type == TravelBonusType.HEROES_FROM_PREVIOUS_SCENARIO) {
            var heroes:Array<GHeroInstance>;
            for(node in campaignState.camp.scenarios[bonus.info2].crossoverHeroes) {
                var h = CampaignState.crossoverDeserialize(node);
                heroes.push(h);
            }
            crossoverHeroes.heroesFromAnyPreviousScenarios = crossoverHeroes.heroesFromPreviousScenario = heroes;
        } else {
            if(!campaignState.mapsConquered.empty()) {
                var heroes:Array<GHeroInstance> = [];
                for(node in campaignState.camp.scenarios[campaignState.mapsConquered.back()].crossoverHeroes) {
                    var h = CampaignState.crossoverDeserialize(node);
                    heroes.push(h);
                }
                crossoverHeroes.heroesFromAnyPreviousScenarios = crossoverHeroes.heroesFromPreviousScenario = heroes;
                crossoverHeroes.heroesFromPreviousScenario = heroes;

                for(mapNr in campaignState.mapsConquered) {
                    // create a list of deleted heroes
                    var scenario = campaignState.camp.scenarios[mapNr];
                    var lostCrossoverHeroes = scenario.getLostCrossoverHeroes();

                    // remove heroes which didn't reached the end of the scenario, but were available at the start
                    for(hero in lostCrossoverHeroes) {
                        vstd.erase_if(crossoverHeroes.heroesFromAnyPreviousScenarios, function(h:GHeroInstance) {
                            return hero.subID == h.subID;
                        });
                    }

                    // now add heroes which completed the scenario
                    for(node in scenario.crossoverHeroes) {
                        var hero = CampaignState.crossoverDeserialize(node);
                            // add new heroes and replace old heroes with newer ones
                        var it = range.find_if(crossoverHeroes.heroesFromAnyPreviousScenarios, function(h:GHeroInstance) {
                            return hero.subID == h.subID;
                        });
                        if (it != crossoverHeroes.heroesFromAnyPreviousScenarios.end()) {
                            // replace old hero with newer one
                            crossoverHeroes.heroesFromAnyPreviousScenarios[it - crossoverHeroes.heroesFromAnyPreviousScenarios.begin()] = hero;
                        } else {
                            // add new hero
                            crossoverHeroes.heroesFromAnyPreviousScenarios.push_back(hero);
                        }
                    }
                }
            }
        }

        return crossoverHeroes;
    }    

}