package gamestate;

import herobonus.BonusSystemNodeType;
import mapObjects.misc.GObelisk;
import mapObjects.quest.GKeys;
import mapObjects.ArmedInstance;
import mapObjects.quest.GSeerHut;
import mapObjects.misc.GSubterraneanGate;
import mapObjects.IBoatGenerator;
import mapping.PlayerInfo;
import constants.BuildingID;
import artifacts.Artifact;
import constants.id.SlotId;
import constants.id.CreatureId;
import constants.ArtifactId;
import constants.SpellId;
import artifacts.ArtifactInstance;
import netpacks.ArtifactLocation;
import herobonus.BonusType;
import herobonus.BonusSource;
import herobonus.Bonus;
import herobonus.BonusDuration;
import constants.SecondarySkill;
import constants.GameConstants;
import res.ResType;
import startinfo.StartInfoMode;
import filesystem.FileCache;
import res.ResourceSet.TResources;
import mapping.campaign.TravelBonus;
import mapping.campaign.ScenarioTravel;
import mapObjects.constructors.DwellingInstanceConstructor;
import gamecallback.NonConstInfoCallback;
import constants.PlayerRelations;
import artifacts.Artifact.ArtClass;
import mapObjects.town.CreGenLeveledInfo;
import mapObjects.town.GDwelling;
import mapObjects.town.CreGenAsCastleInfo;
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

using Reflect;

class GameState extends NonConstInfoCallback {
    public var scenarioOps:StartInfo;
    public var currentPlayer:PlayerColor; //ID of player currently having turn
    public var curB:BattleInfo; //current battle
    public var day:Int; //total number of days in game
    public var map:MapBody;
    public var players:Map<PlayerColor, PlayerState>;
    public var teams:Map<TeamID, TeamState>;
    public var globalEffects:BonusSystemNode;
    public var hpool:HeroesPool;
//    public var rumor:RumorState;

    public function new() {
        super();
        _gs = this;
        scenarioOps = new StartInfo();
        hpool = new HeroesPool();
        players = new Map<PlayerColor, PlayerState>();
        teams = new Map<TeamID, TeamState>();
        globalEffects = new BonusSystemNode();
        globalEffects.setDescription("Global effects");
        globalEffects.setNodeType(BonusSystemNodeType.GLOBAL_EFFECTS);
        day = 0;

        initPlayers();
    }

    //stub
    private function initPlayers() {
        scenarioOps.playerInfos.set(new PlayerColor(0), new PlayerSettings());
        scenarioOps.playerInfos.set(new PlayerColor(1), new PlayerSettings());
        scenarioOps.playerInfos.set(new PlayerColor(2), new PlayerSettings());
        scenarioOps.playerInfos.set(new PlayerColor(3), new PlayerSettings());
        scenarioOps.playerInfos.set(new PlayerColor(4), new PlayerSettings());
    }

    public function init(mapService:IMapService, startInfo:StartInfo = null, allowSavingRandomMap:Bool = false) {
        //ToDo
        initNewGame(mapService, "Vial of Life.h3m");

        VLC.instance.arth.initAllowedArtifactsList(map.allowedArtifact);
        trace("Map loaded!");

        day = 0;

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

        // Explicitly initialize static variables
        for (playerColor in players.keys()) {
            GKeys.playerKeyMap[playerColor] = [];
        }
        for (teamId in teams.keys()) {
            GObelisk.visited.set(teamId, 0);
        }

        //logGlobal.debug("\tChecking objectives");
        map.checkForObjectives(); //needs to be run when all objects are properly placed

        var seedAfterInit = Std.random(2147483647);
        trace('Seed after init is $seedAfterInit (before was ${scenarioOps.seedToBeUsed})');
        if (scenarioOps.seedPostInit > 0) {
            //RNG must be in the same state on all machines when initialization is done (otherwise we have desync)
            //assert(scenarioOps.seedPostIit == seedAfterInit);
        } else {
            scenarioOps.seedPostInit = seedAfterInit; //store the post init "seed"
        }
    }

    private function initNewGame(mapService:IMapService, mapName:String) {
        mapService.loadMapHeaderByName(mapName);
        map = mapService.loadMapByName(mapName);
    }

    function initPlayerStates() {
        trace("Creating player entries in gs");
        for(elemKey in scenarioOps.playerInfos.keys())
        {
            var p = new PlayerState();
            p.color = elemKey;
            p.human = scenarioOps.playerInfos[elemKey].isControlledByHuman();
            p.team = map.players[elemKey.getNum()].team;
            players[elemKey] = p;

            if (!teams.exists(p.team)) {
                teams.set(p.team, new TeamState());
            }
            teams[p.team].id = p.team;//init team
            teams[p.team].players.push(elemKey);//add player to team
        }
    }

    function placeCampaignHeroes() {
/*        if (scenarioOps.campState != null) {
            // place bonus hero
            var campaignBonus = scenarioOps.campState.getBonusForCurrentMap();
            var campaignGiveHero = campaignBonus != null && campaignBonus.type == TravelBonusType.HERO;

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

            if(crossoverHeroes.heroesFromAnyPreviousScenarios.length > 0) {
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
                    if (hero != null) {
                        removedHeroes.push(hero);
                        map.heroesOnMap.remove(hero);
                        map.objects[hero.id.getNum()] = null;
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
                        map.instanceNames.remove(obj.instanceName);
                        map.objects.splice(heroPlaceholder.id.getNum(), 1);
                    }
                }

                // now add removed heroes again with unused type ID
                for(hero in removedHeroes) {
                    var heroTypeId = 0;
                    if(hero.ID == Obj.HERO) {
                        heroTypeId = pickUnusedHeroTypeRandomly(hero.tempOwner);
                    } else if(hero.ID == Obj.PRISON) {
                        var unusedHeroTypeIds = getUnusedAllowedHeroes();
                        if(unusedHeroTypeIds.length > 0) {
                            heroTypeId = unusedHeroTypeIds[Std.random(unusedHeroTypeIds.length)].getNum();
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
*/
    }

    function initGrailPosition() {
    }

    function initRandomFactionsForPlayers() {
        trace("\tPicking random factions for players");
        for (playerColor in scenarioOps.playerInfos.keys()) {
            var playerSettings = scenarioOps.playerInfos[playerColor];
            if (playerSettings.castle == -1) {
                var randomID = Std.random(map.players[playerColor.getNum()].allowedFactions.length - 1);
                playerSettings.castle = map.players[playerColor.getNum()].allowedFactions[randomID];
            }
        }
    }

    function randomizeMapObjects() {
        trace("\tRandomizing objects");
        for (obj in map.objects) {
            if (obj == null) continue;

            randomizeObject(obj);

            //handle Favouring Winds - mark tiles under it
            if(obj.ID == Obj.FAVORABLE_WINDS) {
                for (i in 0...obj.getWidth()) {
                    for (j in 0...obj.getHeight()) {
                        var pos = Int3.substraction(obj.pos, new Int3(i, j, 0));
                        if (map.isInTheMap(pos)) {
                            map.getTileByInt3(pos).extTileFlags |= 128;
                        }
                    }
                }
            }
        }
    }

    function placeStartingHeroes() {
        trace("Giving starting hero");

        for(playerColor in scenarioOps.playerInfos.keys()) {
            var playerSetting = scenarioOps.playerInfos.get(playerColor);
            var playerInfo = map.players[playerColor];
            if (playerInfo.generateHeroAtMainTown && playerInfo.hasMainTown) {
                // Do not place a starting hero if the hero was already placed due to a campaign bonus
                if(scenarioOps.campState != null) {
                    var campaignBonus = scenarioOps.campState.getBonusForCurrentMap();
                    if(campaignBonus != null) {
                        if (campaignBonus.type == TravelBonusType.HERO && playerColor == (campaignBonus.info1:PlayerColor))
                            continue;
                    }
                }

                var heroTypeId = pickNextHeroType(playerColor);
                if (playerSetting.hero == -1) {
                    playerSetting.hero = heroTypeId;
                }

                placeStartingHero(playerColor, (heroTypeId:HeroTypeId), playerInfo.posOfMainTown);
            }
        }
    }

    function initStartingResources() {
        function convertToResourceSet(d:Dynamic):Array<Int> {
            return [d.field("wood"), d.field("mercury"), d.field("ore"), d.field("sulfur"), d.field("crystal"), d.field("gems"), d.field("gold"), d.field("mithril")];
        }

        trace("Setting up resources");
        var config:Dynamic = FileCache.instance.getConfig("config/startres.json");
        var vector:Array<Dynamic> = config.field("difficulty");
        var level:Dynamic = vector[scenarioOps.difficulty];

        var startresAI:TResources = convertToResourceSet(level.field("ai"));
        var startresHuman:TResources = convertToResourceSet(level.field("human"));

        for (playerState in players) {
           if (playerState.human) {
               playerState.resources = startresHuman;
           } else {
               playerState.resources = startresAI;
           }
        }

        var getHumanPlayerInfo = function():Array<PlayerSettings> {
            var ret = [];
            for (playerSettings in scenarioOps.playerInfos) {
                if (playerSettings.isControlledByHuman()) {
                    ret.push(playerSettings);
                }
            }
            return ret;
        }

        //give start resource bonus in case of campaign
        if (scenarioOps.mode == StartInfoMode.CAMPAIGN) {
            var chosenBonus = scenarioOps.campState.getBonusForCurrentMap();
            if (chosenBonus != null && chosenBonus.type == TravelBonusType.RESOURCE) {
                var people:Array<PlayerSettings> = getHumanPlayerInfo(); //players we will give resource bonus
                for (playerSettings in people) {
                    var res:Array<Int> = []; //resources we will give
                    switch (chosenBonus.info1) {
                        case 0 | 1 | 2 | 3 | 4 | 5 | 6:
                            res.push(chosenBonus.info1);
                            break;
                        case 0xFD: //wood+ore
                            res.push(ResType.WOOD); res.push(ResType.ORE);
                            break;
                        case 0xFE:  //rare
                            res.push(ResType.MERCURY); res.push(ResType.SULFUR); res.push(ResType.CRYSTAL); res.push(ResType.GEMS);
                            break;
                        default:
                            trace("???");
                            break;
                    }
                    //increasing resource quantity
                    for (re in res) {
                        players[playerSettings.color].resources[re] += chosenBonus.info2;
                    }
                }
            }
        }
    }

    function initHeroes() {
        for (hero in map.heroesOnMap) { //heroes instances initialization
            if (hero.getOwner() == PlayerColor.UNFLAGGABLE) {
                trace("Hero with uninitialized owner!");
                continue;
            }

            hero.initHero();
            getPlayer(hero.getOwner()).heroes.push(hero);
            map.allHeroes[hero.type.ID.getNum()] = hero;
        }

        for (obj in map.objects) {//prisons
            if(obj != null && obj.ID == Obj.PRISON) {
                map.allHeroes[obj.subID] = cast obj;
            }
        }

        var heroesToCreate:Array<HeroTypeId> = getUnusedAllowedHeroes(); //ids of heroes to be created and put into the pool
        for (ph in map.predefinedHeroes) {
            if(heroesToCreate.indexOf((ph.subID:HeroTypeId)) == -1)
                continue;
            ph.initHero();
            hpool.heroesPool[ph.subID] = ph;
            hpool.pavailable[ph.subID] = 0xff;
            heroesToCreate.remove(ph.type.ID);

            map.allHeroes[ph.subID] = ph;
        }

        for (htype in heroesToCreate) {//all not used allowed heroes go with default state into the pool
            var vhi = new GHeroInstance();
            vhi.initHeroWithType(htype);

            var typeID:Int = htype;
            map.allHeroes[typeID] = vhi;
            hpool.heroesPool[typeID] = vhi;
            hpool.pavailable[typeID] = 0xff;
        }

        for(elem in map.disposedHeroes) {
            hpool.pavailable[elem.heroId] = elem.players;
        }

        if (scenarioOps.mode == StartInfoMode.CAMPAIGN) {//give campaign bonuses for specific / best hero
            var chosenBonus = scenarioOps.campState.getBonusForCurrentMap();
            if (chosenBonus != null && chosenBonus.isBonusForHero() && chosenBonus.info1 != 0xFFFE) {//exclude generated heroes
                //find human player
                var humanPlayer:PlayerColor = PlayerColor.NEUTRAL;
                for (playerColor in players.keys()) {
                    var playerState = players.get(playerColor);
                    if (playerState.human) {
                        humanPlayer = playerColor;
                        break;
                    }
                }
                trace(humanPlayer != PlayerColor.NEUTRAL);

                var heroes:Array<GHeroInstance> = players[humanPlayer].heroes;

                if (chosenBonus.info1 == 0xFFFD) {//most powerful
                    var maxB:Int = -1;
                    for (b in 0...heroes.length) {
                        if (maxB == -1 || heroes[b].getTotalStrength() > heroes[maxB].getTotalStrength()) {
                            maxB = b;
                        }
                    }
                    if(maxB < 0) {
                        trace("Cannot give bonus to hero cause there are no heroes!");
                    } else {
                        giveCampaignBonusToHero(heroes[maxB]);
                    }
                } else {//specific hero
                    for (heroe in heroes) {
                        if (heroe.subID == chosenBonus.info1) {
                            giveCampaignBonusToHero(heroe);
                            break;
                        }
                    }
                }
            }
        }
    }

    function initStartingBonus() {
        if (scenarioOps.mode == StartInfoMode.CAMPAIGN) {
            return;
        }
        // These are the single scenario bonuses; predefined
        // campaign bonuses are spread out over other init* functions.

        trace("Starting bonuses");
        for (playerColor in players.keys()) {
            var playerState = players.get(playerColor);
            //starting bonus
            if (scenarioOps.playerInfos[playerColor].bonus == PlayerSettingsBonus.RANDOM)
                scenarioOps.playerInfos[playerColor].bonus = (Std.random(2):PlayerSettingsBonus);
            switch(scenarioOps.playerInfos[playerColor].bonus) {
                case PlayerSettingsBonus.GOLD:
                    playerState.resources[ResType.GOLD] += (5 + Std.random(10 - 5)) * 100;
                case PlayerSettingsBonus.RESOURCE:
                    var res = VLC.instance.townh.factions[scenarioOps.playerInfos[playerColor].castle].town.primaryRes;
                    if (res == ResType.WOOD_AND_ORE) {
                        var amount = 5 + Std.random(10 - 5);
                        playerState.resources[ResType.WOOD] += amount;
                        playerState.resources[ResType.ORE] += amount;
                    } else {
                        playerState.resources[res] += (3 + Std.random(6 - 3));
                    }
                case PlayerSettingsBonus.ARTIFACT:
                    if (playerState.heroes.length == 0) {
                        trace("Cannot give starting artifact - no heroes!");
                        break;
                    }
                    var toGive:Artifact;
                    toGive = VLC.instance.arth.artifacts[VLC.instance.arth.pickRandomArtifact(ArtClass.ART_TREASURE)];

                    var hero:GHeroInstance = playerState.heroes[0];
                    giveHeroArtifact(hero, toGive.id);
                default:
            }
        }
    }

    function initTowns() {
        trace("Towns");

        //campaign bonuses for towns
        if (scenarioOps.mode == StartInfoMode.CAMPAIGN) {
            var chosenBonus = scenarioOps.campState.getBonusForCurrentMap();

            if (chosenBonus != null && chosenBonus.type == TravelBonusType.BUILDING) {
                for (g in 0...map.towns.length) {
                    var owner:PlayerState = getPlayer(map.towns[g].getOwner());
                    if (owner != null) {
                        var pi:PlayerInfo = map.players[owner.color.getNum()];

                        if (owner.human && //human-owned
                        map.towns[g].pos == pi.posOfMainTown)
                        {
                            map.towns[g].builtBuildings.push(
                                BuildingHandler.campToERMU(chosenBonus.info1, map.towns[g].subID, map.towns[g].builtBuildings));
                            break;
                        }
                    }
                }
            }
        }

        GTownInstance.universitySkills.splice(0, GTownInstance.universitySkills.length);
        for (i in 0...4)
            GTownInstance.universitySkills.push(14+i);//skills for university

        for (elem in map.towns) {
            var vti:GTownInstance = elem;
            if(vti.town == null) {
                vti.town = VLC.instance.townh.factions[vti.subID].town;
            }
            if(vti.name == "") {
                vti.name = vti.town.names[Std.random(vti.town.names.length)];
            }

            //init buildings
            if (vti.builtBuildings.contains(BuildingID.DEFAULT)) {//give standard set of buildings
                vti.builtBuildings.remove(BuildingID.DEFAULT);
                vti.builtBuildings.push(BuildingID.VILLAGE_HALL);
                if(vti.tempOwner != PlayerColor.NEUTRAL)
                    vti.builtBuildings.push(BuildingID.TAVERN);

                vti.builtBuildings.push(BuildingID.DWELL_FIRST);
                // TODO: WHY such in original?
                if (Std.random(1) == 1) {
                    vti.builtBuildings.push(BuildingID.DWELL_LVL_2);
                }
            }

            //#1444 - remove entries that don't have buildings defined (like some unused extra town hall buildings)
            for (bid in vti.builtBuildings) {
                if (!vti.town.buildings.exists(bid) || vti.town.buildings.get(bid) == null) {
                    vti.builtBuildings.remove(bid);
                }
            }

            if (vti.builtBuildings.contains(BuildingID.SHIPYARD) && vti.shipyardStatus() == GeneratorState.TILE_BLOCKED) {
                vti.builtBuildings.remove(BuildingID.SHIPYARD);//if we have harbor without water - erase it (this is H3 behaviour)
            }

            //init hordes
            for (i in 0...GameConstants.CREATURES_PER_TOWN) {
                if (vti.builtBuildings.contains(-31-i)) { //if we have horde for this level
                    vti.builtBuildings.remove(((-31-i):BuildingID));//remove old ID
                    if (vti.town.hordeLvl.get(0) == i) { //if town first horde is this one
                        vti.builtBuildings.push(BuildingID.HORDE_1);//add it
                        if (vti.builtBuildings.contains(BuildingID.DWELL_UP_FIRST+i)) {//if we have upgraded dwelling as well
                            vti.builtBuildings.push(BuildingID.HORDE_1_UPGR);//add it as well
                        }
                    }
                    if (vti.town.hordeLvl.get(1) == i) {//if town second horde is this one
                        vti.builtBuildings.push(BuildingID.HORDE_2);
                        if (vti.builtBuildings.contains(BuildingID.DWELL_UP_FIRST+i)) {
                            vti.builtBuildings.push(BuildingID.HORDE_2_UPGR);
                        }
                    }
                }
            }

            //Early check for #1444-like problems
            for (building in vti.builtBuildings) {
                if (vti.town.buildings.get(building) == null) {
                    trace('$building is null!');
                }
            }

            //town events
            for (ev in vti.events) {
                for (i in 0...GameConstants.CREATURES_PER_TOWN) {
                    if (ev.buildings.contains(-31-i)) { //if we have horde for this level
                        ev.buildings.remove(((-31-i):BuildingID));
                        if (vti.town.hordeLvl.get(0) == i) {
                            ev.buildings.push(BuildingID.HORDE_1);
                        }
                        if (vti.town.hordeLvl.get(1) == i) {
                            ev.buildings.push(BuildingID.HORDE_2);
                        }
                    }
                }
            }
            //init spells
            vti.spells = [for (i in 0...GameConstants.SPELL_LEVELS) []];

            for (z in 0...vti.obligatorySpells.length) {
                var s = vti.obligatorySpells[z].toSpell();
                vti.spells[s.level-1].push(s.id);
                vti.possibleSpells.remove(s.id);
            }
            while (vti.possibleSpells.length > 0) {
                var total = 0;
                var sel = -1;

                for (ps in 0...vti.possibleSpells.length) {
                    total += vti.possibleSpells[ps].toSpell().getProbability(vti.subID);
                }

                if (total == 0) // remaining spells have 0 probability
                    break;

                var r = Std.random(total - 1);
                for (ps in 0...vti.possibleSpells.length) {
                    r -= vti.possibleSpells[ps].toSpell().getProbability(vti.subID);
                    if (r < 0) {
                        sel = ps;
                        break;
                    }
                }
                if (sel<0) {
                    sel = 0;
                }

                var s = vti.possibleSpells[sel].toSpell();
                vti.spells[s.level-1].push(s.id);
                vti.possibleSpells.remove(s.id);
            }
            vti.possibleSpells.splice(0, vti.possibleSpells.length);
            if (vti.getOwner() != PlayerColor.NEUTRAL) {
                getPlayer(vti.getOwner()).towns.push(vti);
            }
        }
    }

    function initMapObjects() {
        trace("Object initialization");
        VLC.instance.creh.removeBonusesFromAllCreatures();

        for (obj in map.objects) {
            if (obj != null) {
                trace('Calling Init for object ${obj.id}, ${obj.typeName}, ${obj.subTypeName}');
                obj.initObj();
            }
        }
        for (obj in map.objects) {
            if (obj == null)
                continue;

            switch (obj.ID) {
                case Obj.QUEST_GUARD | Obj.SEER_HUT:
                    var q = cast(obj, GSeerHut);
                    //assert (q);
                    q.setObjToKill();
                default:
            }
        }
        GSubterraneanGate.postInit(); //pairing subterranean gates

        map.calculateGuardingGreaturePositions(); //calculate once again when all the guards are placed and initialized
    }

    function buildBonusSystemTree() {
        buildGlobalTeamPlayerTree();
        attachArmedObjects();

        for (t in map.towns) {
            t.deserializationFix();
        }
        // CStackInstance <-> CCreature, CStackInstance <-> CArmedInstance, CArtifactInstance <-> CArtifact
        // are provided on initializing / deserializing
    }

    function initVisitingAndGarrisonedHeroes() {
        for (playerColor in players.keys()) {
            var playerState = players[playerColor];
            if (playerColor == PlayerColor.NEUTRAL)
                continue;

            //init visiting and garrisoned heroes
            for (h in playerState.heroes) {
                for (t in playerState.towns) {
                    var vistile:Int3 = t.pos;
                    vistile.x--; //tile next to the entrance
                    if (vistile == h.pos || h.pos == t.pos) {
                        t.setVisitingHero(h);
                        if (h.pos == t.pos) {//visiting hero placed in the editor has same pos as the town - we need to correct it
                            map.removeBlockVisTiles(h);
                            h.pos.x -= 1;
                            map.addBlockVisTiles(h);
                        }
                        break;
                    }
                }
            }
        }

        for (hero in map.heroesOnMap) {
            if (hero.visitedTown != null) {
                if (hero.visitedTown.visitingHero != hero) {
                    throw "hero.visitedTown.visitingHero != hero";
                }
            }
        }
    }

    function initFogOfWar() {
        trace("Fog of war"); //FIXME: should be initialized after all bonuses are set
        var levelsCount = map.twoLevel ? 2 : 1;
        for (teamState in teams) {
            // 3-dimensional array
            teamState.fogOfWarMap = [for(i in 0...map.width) [for(i in 0...map.height) [for(i in 0...levelsCount) false]]];

            for (obj in map.objects) {
                if (obj == null || teamState.players.indexOf(obj.tempOwner) == -1) continue; //not a flagged object

                var tiles:Array<Int3> = [];
                getTilesInRange(tiles, obj.getSightCenter(), obj.getSightRadius(), obj.tempOwner, 1);
                for (tile in tiles) {
                    teamState.fogOfWarMap[tile.x][tile.y][tile.z] = true;
                }
            }
        }
    }

    function pickUnusedHeroTypeRandomly(owner:PlayerColor) {
        //list of available heroes for this faction and others
        var factionHeroes:Array<HeroTypeId> = [];
        var otherHeroes:Array<HeroTypeId> = [];

        var ps:PlayerSettings = scenarioOps.getIthPlayersSettings(owner);
        var unusedAllowedHeroes:Array<HeroTypeId> = getUnusedAllowedHeroes();
        for (hid in unusedAllowedHeroes) {
            if(VLC.instance.heroh.heroes[hid.getNum()].heroClass.faction == ps.castle) {
                factionHeroes.push(hid);
            } else {
                otherHeroes.push(hid);
            }
        }

        // select random hero native to "our" faction
        if(factionHeroes.length > 0) {
            return factionHeroes[Std.random(factionHeroes.length - 1)].getNum();
        }

        trace('Cannot find free hero of appropriate faction for player ${owner.getStr()} - trying to get first available...');
        if(otherHeroes.length > 0) {
            return otherHeroes[Std.random(otherHeroes.length - 1)].getNum();
        }

        trace("No free allowed heroes!");
        var notAllowedHeroesButStillBetterThanCrash = getUnusedAllowedHeroes(true);
        if (notAllowedHeroesButStillBetterThanCrash.length > 0) {
            return notAllowedHeroesButStillBetterThanCrash[0].getNum();
        }

        trace("No free heroes at all!");
        return -1; // no available heroes at all
    }

    function getUnusedAllowedHeroes(alsoIncludeNotAllowed:Bool = false):Array<HeroTypeId> {
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
        hero.pos.add(hero.getVisitableOffset());
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
        var crossoverHeroes = new CrossoverHeroesList();

        var campaignState = scenarioOps.campState;
        var bonus = campaignState.getBonusForCurrentMap();
        if (bonus != null && bonus.type == TravelBonusType.HEROES_FROM_PREVIOUS_SCENARIO) {
            var heroes:Array<GHeroInstance> = [];
            for(node in campaignState.camp.scenarios[bonus.info2].crossoverHeroes) {
                var h = CampaignState.crossoverDeserialize(node);
                heroes.push(h);
            }
            crossoverHeroes.heroesFromAnyPreviousScenarios = crossoverHeroes.heroesFromPreviousScenario = heroes;
        } else {
            if(campaignState.mapsConquered.length > 0) {
                var heroes:Array<GHeroInstance> = [];
                for(node in campaignState.camp.scenarios[campaignState.mapsConquered[campaignState.mapsConquered.length - 1]].crossoverHeroes) {
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
                        for (h in crossoverHeroes.heroesFromAnyPreviousScenarios.copy()) {
                            if (hero.subID == h.subID) {
                                crossoverHeroes.heroesFromAnyPreviousScenarios.remove(h);
                            }
                        };
                    }

                    // now add heroes which completed the scenario
                    for(node in scenario.crossoverHeroes) {
                        var hero = CampaignState.crossoverDeserialize(node);
                            // add new heroes and replace old heroes with newer ones
                        var hero2:GHeroInstance = null;
                        var hero2Index = -1;
                        for (h in crossoverHeroes.heroesFromAnyPreviousScenarios) {
                            if (hero.subID == h.subID) {
                                hero2Index = crossoverHeroes.heroesFromAnyPreviousScenarios.indexOf(h);
                                hero2 = hero;
                                break;
                            }
                        };
                        if (hero2 != null) {
                            // replace old hero with newer one
                            crossoverHeroes.heroesFromAnyPreviousScenarios[hero2Index] = hero;
                        } else {
                            // add new hero
                            crossoverHeroes.heroesFromAnyPreviousScenarios.push(hero);
                        }
                    }
                }
            }
        }

        return crossoverHeroes;
    }

    function generateCampaignHeroesToReplace(crossoverHeroes:CrossoverHeroesList):Array<CampaignHeroReplacement> {
        var campaignHeroReplacements:Array<CampaignHeroReplacement> = [];

        //selecting heroes by type
        for (obj in map.objects) {
            if(obj != null && obj.ID == Obj.HERO_PLACEHOLDER) {
                var heroPlaceholder:GHeroPlaceholder = cast obj;
                if (heroPlaceholder.subID != 0xFF) { //select by type
                    var itHero:GHeroInstance = null;
                    for (hero in crossoverHeroes.heroesFromAnyPreviousScenarios) {
                        if (hero.subID == heroPlaceholder.subID) {
                            itHero = hero;
                            break;
                        }
                    };

                    if (itHero != null) {
                        crossoverHeroes.removeHeroFromBothLists(itHero);
                        campaignHeroReplacements.push(new CampaignHeroReplacement(itHero.copy(), heroPlaceholder.id));
                    }
                }
            }
        }

        //selecting heroes by power
        crossoverHeroes.heroesFromPreviousScenario.sort(function (a:GHeroInstance, b:GHeroInstance) {
            return a.getHeroStrength() > b.getHeroStrength() ? 1 : (a.getHeroStrength() < b.getHeroStrength() ? -1 : 0);
        }); //sort, descending strength

        // sort hero placeholders descending power
        var heroPlaceholders:Array<GHeroPlaceholder> = [];
        for (obj in map.objects) {
            if (obj != null && obj.ID == Obj.HERO_PLACEHOLDER) {
                var heroPlaceholder:GHeroPlaceholder = cast obj;
                if(heroPlaceholder.subID == 0xFF) {//select by power
                    heroPlaceholders.push(heroPlaceholder);
                }
            }
        }
        heroPlaceholders.sort(function(a:GHeroPlaceholder, b:GHeroPlaceholder) {
            return a.power > b.power ? 1 : (a.power < b.power ? -1 : 0);
        });

        for (i in 0...heroPlaceholders.length) {
            var heroPlaceholder = heroPlaceholders[i];
            if(crossoverHeroes.heroesFromPreviousScenario.length > i) {
                var hero = crossoverHeroes.heroesFromPreviousScenario[i];
                campaignHeroReplacements.push(new CampaignHeroReplacement(hero.copy(), heroPlaceholder.id));
            }
        }

        return campaignHeroReplacements;
    }

    function randomizeObject(cur:GObjectInstance) {
        var ran:{first:Obj, second:Int} = pickObject(cur);
        if (ran.first == Obj.NO_OBJ || ran.second < 0) {//this is not a random object, or we couldn't find anything
            if (cur.ID == Obj.TOWN) {
                cur.setType(cur.ID, cur.subID); // update def, if necessary
            }
        } else if (ran.first == Obj.HERO) {//special code for hero
            var h:GHeroInstance = cast cur;
            cur.setType(ran.first, ran.second);
            map.heroesOnMap.push(h);
        } else if (ran.first == Obj.TOWN) {//special code for town
            var t:GTownInstance = cast cur;
            cur.setType(ran.first, ran.second);
            map.towns.push(t);
        } else {
            cur.setType(ran.first, ran.second);
        }
    }

    function pickObject(obj:GObjectInstance):{first:Obj, second:Int} {
        switch(obj.ID) {
            case Obj.RANDOM_ART:
                return {first:Obj.ARTIFACT, second:VLC.instance.arth.pickRandomArtifact(ArtClass.ART_TREASURE | ArtClass.ART_MINOR | ArtClass.ART_MAJOR | ArtClass.ART_RELIC)};
            case Obj.RANDOM_TREASURE_ART:
                return {first:Obj.ARTIFACT, second:VLC.instance.arth.pickRandomArtifact(ArtClass.ART_TREASURE)};
            case Obj.RANDOM_MINOR_ART:
                return {first:Obj.ARTIFACT, second:VLC.instance.arth.pickRandomArtifact(ArtClass.ART_MINOR)};
            case Obj.RANDOM_MAJOR_ART:
                return {first:Obj.ARTIFACT, second:VLC.instance.arth.pickRandomArtifact(ArtClass.ART_MAJOR)};
            case Obj.RANDOM_RELIC_ART:
                return {first:Obj.ARTIFACT, second:VLC.instance.arth.pickRandomArtifact(ArtClass.ART_RELIC)};
            case Obj.RANDOM_HERO:
                return {first:Obj.HERO, second:pickNextHeroType(obj.tempOwner)};
            case Obj.RANDOM_MONSTER:
                return {first:Obj.MONSTER, second:VLC.instance.creh.pickRandomMonster()};
            case Obj.RANDOM_MONSTER_L1:
                return {first:Obj.MONSTER, second:VLC.instance.creh.pickRandomMonster(1)};
            case Obj.RANDOM_MONSTER_L2:
                return {first:Obj.MONSTER, second:VLC.instance.creh.pickRandomMonster(2)};
            case Obj.RANDOM_MONSTER_L3:
                return {first:Obj.MONSTER, second:VLC.instance.creh.pickRandomMonster(3)};
            case Obj.RANDOM_MONSTER_L4:
                return {first:Obj.MONSTER, second:VLC.instance.creh.pickRandomMonster(4)};
            case Obj.RANDOM_RESOURCE:
                return {first:Obj.RESOURCE, second:Std.random(6)}; //now it's OH3 style, use %8 for mithril
            case Obj.RANDOM_TOWN:
                var align:PlayerColor = (cast(obj, GTownInstance).alignment:PlayerColor);
                var f:Int; // can be negative (for random)
                if ((align:Int) >= (PlayerColor.PLAYER_LIMIT:Int)) {//same as owner / random
                    if ((obj.tempOwner:Int) >= (PlayerColor.PLAYER_LIMIT:Int)) {
                        f = -1; //random
                    } else {
                        f = scenarioOps.getIthPlayersSettings(obj.tempOwner).castle;
                    }
                } else {
                    f = scenarioOps.getIthPlayersSettings(align).castle;
                }
                if (f<0) {
                    do
                    {
                        f = Std.random(VLC.instance.townh.factions.length - 1);
                    }
                    while (VLC.instance.townh.factions[f].town == null); // find playable faction
                }
                return {first: Obj.TOWN, second: f};
            case Obj.RANDOM_MONSTER_L5:
                return {first:Obj.MONSTER, second:VLC.instance.creh.pickRandomMonster(5)};
            case Obj.RANDOM_MONSTER_L6:
                return {first:Obj.MONSTER, second:VLC.instance.creh.pickRandomMonster(6)};
            case Obj.RANDOM_MONSTER_L7:
                return {first:Obj.MONSTER, second:VLC.instance.creh.pickRandomMonster(7)};
            case Obj.RANDOM_DWELLING:
            case Obj.RANDOM_DWELLING_LVL:
            case Obj.RANDOM_DWELLING_FACTION:
                var dwl:GDwelling = cast obj;
                var faction:Int;

                //if castle alignment available
                var info:CreGenAsCastleInfo = cast(dwl.info, CreGenAsCastleInfo);
                if (info != null) {
                    faction = Std.random(VLC.instance.townh.factions.length - 1);
                    if (info.asCastle != null && info.instanceId != "") {
                        if (!map.instanceNames.exists(info.instanceId)) {
                            trace("Map object not found: %s", info.instanceId);
                        } else {
                            var elem = map.instanceNames.get(info.instanceId);
                            if(elem.ID == Obj.RANDOM_TOWN) {
                                randomizeObject(elem); //we have to randomize the castle first
                                faction = elem.subID;
                            }
                            else if(elem.ID == Obj.TOWN) {
                                faction = elem.subID;
                            } else {
                                trace("Map object must be town: %s", info.instanceId);
                            }
                        }
                    } else if (info.asCastle != null) {
                        for(elem in map.objects) {
                            if(elem == null)
                                continue;

                            if (elem.ID == Obj.RANDOM_TOWN
                            && cast(elem, GTownInstance).identifier == info.identifier) {
                                randomizeObject(elem); //we have to randomize the castle first
                                faction = elem.subID;
                                break;
                            }
                            else if(elem.ID == Obj.TOWN && cast(elem, GTownInstance).identifier == info.identifier) {
                                faction = elem.subID;
                                break;
                            }
                        }
                    } else {
                        var temp:Array<Int> = [];

                        for (i in 0...info.allowedFactions.length) {
                            if (info.allowedFactions[i]) {
                                if (temp.indexOf(i) == -1) temp.push(i);
                            }
                        }

                        if (temp.length == 0) {
                            trace("Random faction selection failed. Nothing is allowed. Fall back to random.");
                        } else {
                            faction = temp[Std.random(temp.length - 1)];
                        }
                    }
                } else {// castle alignment fixed
                    faction = obj.subID;
                }

                var level:Int;

                //if level set to range
                var info:CreGenLeveledInfo = cast(dwl.info, CreGenLeveledInfo);
                if (info != null) {
                    level = info.minLevel + Std.random(info.maxLevel - info.minLevel);
                } else {// fixed level
                    level = obj.subID;
                }

                dwl.info = null;

                var result = {first:Obj.NO_OBJ, second:-1};
                var cid = VLC.instance.townh.factions[faction].town.creatures[level][0];

                //NOTE: this will pick last dwelling with this creature (Mantis #900)
                //check for block map equality is better but more complex solution
                var testID = function(primaryID:Obj):Void {
                    var dwellingIDs = VLC.instance.objtypeh.knownSubObjects(primaryID);
                    for (entry in dwellingIDs) {
                        var handler:DwellingInstanceConstructor = cast VLC.instance.objtypeh.getHandlerFor(primaryID, entry);

                        if (handler.producesCreature(VLC.instance.creh.creatures[cid])) {
                            result = {first:primaryID, second:entry};
                        }
                    }
                }

                testID(Obj.CREATURE_GENERATOR1);
                if (result.first == Obj.NO_OBJ) {
                    testID(Obj.CREATURE_GENERATOR4);
                }

                if (result.first == Obj.NO_OBJ) {
                    trace("Error: failed to find dwelling for %s of level %d", VLC.instance.townh.factions[faction].name, level);
                    result = {first:Obj.CREATURE_GENERATOR1, second:VLC.instance.objtypeh.knownSubObjects(Obj.CREATURE_GENERATOR1)[VLC.instance.objtypeh.knownSubObjects(Obj.CREATURE_GENERATOR1).length - 1]};
                }

                return result;
            default:
        }
        return {first:Obj.NO_OBJ, second:-1};
    }

    function pickNextHeroType(owner:PlayerColor) {
        var ps:PlayerSettings = scenarioOps.getIthPlayersSettings(owner);
        if (ps.hero >= 0 && isUsedHero((ps.hero:HeroTypeId)) == null) { //we haven't used selected hero
           return ps.hero;
        }

        return pickUnusedHeroTypeRandomly(owner);
    }

    function isUsedHero(hid:HeroTypeId) {
        return getUsedHero(hid);
    }

    function getUsedHero(hid:HeroTypeId):GHeroInstance {
        for (hero in map.heroesOnMap) {  //heroes instances initialization
            if (hero.type != null && hero.type.ID == hid) {
                return hero;
            }
        }

        for (obj in map.objects) {//prisons
            if (obj != null && obj.ID == Obj.PRISON ) {
                var hero = cast(obj, GHeroInstance);
                if (hero.type != null && hero.type.ID == hid)
                    return hero;
            }
        }

        return null;
    }

    public function getPlayerRelations(color1:PlayerColor, color2:PlayerColor) {
        if (color1 == color2) {
            return PlayerRelations.SAME_PLAYER;
        }
        
        if (color1 == PlayerColor.NEUTRAL || color2 == PlayerColor.NEUTRAL) { //neutral player has no friends
            return PlayerRelations.ENEMIES;
        }

        var ts:TeamState = getPlayerTeam(color1);
        if (ts != null && ts.players.indexOf(color2) > -1) {
            return PlayerRelations.ALLIES;
        }

        return PlayerRelations.ENEMIES;
    }

    public function isVisible(obj:GObjectInstance, player:Null<PlayerColor>) {
        if (player == null)
            return true;

        //we should always see our own heroes - but sometimes not visible heroes cause crash :?
        if (player == obj.tempOwner)
            return true;

        if (player == PlayerColor.NEUTRAL) //. TODO ??? needed?
            return false;
            //object is visible when at least one blocked tile is visible
        for (fy in 0...obj.getHeight()) {
            for(fx in 0...obj.getWidth()) {
                var pos = Int3.addition(obj.pos, new Int3(-fx, -fy, 0));

                if ( map.isInTheMap(pos) && obj.coveringAt(pos.x, pos.y) && isVisibleAt(pos, player))
                    return true;
            }
        }
        return false;
    }

    public function isVisibleAt(pos:Int3, player:PlayerColor) {
        if(player == PlayerColor.NEUTRAL) {
            return false;
        }
        if(player.isSpectator()) {
            return true;
        }

        return getPlayerTeam(player).fogOfWarMap[pos.x][pos.y][pos.z];
    }

    public function giveCampaignBonusToHero(hero:GHeroInstance) {
        var curBonus:Null<TravelBonus> = scenarioOps.campState.getBonusForCurrentMap();
        if (curBonus == null)
            return;

        if (curBonus.isBonusForHero()) {
            //apply bonus
            switch (curBonus.type) {
                case TravelBonusType.SPELL:
                    hero.addSpellToSpellbook((curBonus.info2:SpellId));
                case TravelBonusType.MONSTER:
                    for (i in 0...GameConstants.ARMY_SIZE) {
                        if (hero.slotEmpty(new SlotId(i))) {
                            hero.addToSlot(new SlotId(i), new CreatureId(curBonus.info2), curBonus.info3);
                            break;
                        }
                    }
                case TravelBonusType.ARTIFACT:
                    _gs.giveHeroArtifact(hero, (curBonus.info2:ArtifactId));
                case TravelBonusType.SPELL_SCROLL:
                    var scroll = ArtifactInstance.createScroll((curBonus.info2:SpellId).toSpell());
                    scroll.putAt(new ArtifactLocation(hero, scroll.firstAvailableSlot(hero.artifactSet)));
                case TravelBonusType.PRIMARY_SKILL:
                    var ptr = curBonus.info2;
                    for (g in 0...GameConstants.PRIMARY_SKILLS) {
                        var val = (ptr & 1<<g) >> g; // get bit by index
                        if (val == 0) {
                            continue;
                        }
                        var bb = new Bonus(BonusDuration.PERMANENT, BonusType.PRIMARY_SKILL, BonusSource.CAMPAIGN_BONUS, val, scenarioOps.campState.currentMap, g);
                        hero.bonusSystemNode.addNewBonus(bb);
                    }
                case TravelBonusType.SECONDARY_SKILL:
                    hero.setSecSkillLevel((curBonus.info2:SecondarySkill), curBonus.info3, true);
                default:
            }
        }
    }

    public function giveHeroArtifact(h:GHeroInstance, aid:ArtifactId) {
        var artifact:Artifact = VLC.instance.arth.artifacts[aid]; //pointer to constant object
        var ai:ArtifactInstance = ArtifactInstance.createNewArtifactInstance(artifact);
        map.addNewArtifactInstance(ai);
        ai.putAt(new ArtifactLocation(h, ai.firstAvailableSlot(h.artifactSet)));
    }

    public function buildGlobalTeamPlayerTree() {
        for (teamState in teams) {
            teamState.attachTo(globalEffects);

            for(teamMember in teamState.players) {
                var p:PlayerState = getPlayer(teamMember);
                //assert(p);
                p.attachTo(teamState);
            }
        }
    }

    public function attachArmedObjects() {
        for (obj in map.objects) {
            var armed:ArmedInstance = Std.isOfType(obj, ArmedInstance) ? cast(obj, ArmedInstance) : null;
            if (armed != null) {
                armed.whatShouldBeAttached().attachTo(armed.whereShouldBeAttached(this));
            }
        }
    }
}