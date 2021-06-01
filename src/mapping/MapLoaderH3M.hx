package mapping;

import filesystem.FileCache;
import constants.ArtifactId;
import constants.ArtifactPosition;
import constants.BuildingID;
import constants.GameConstants;
import constants.id.CreatureId;
import constants.id.ObjectInstanceId;
import constants.id.PlayerColor;
import constants.id.SlotId;
import constants.Obj;
import constants.PrimarySkill;
import constants.SecondarySkill;
import constants.SpellId;
import filesystem.BinaryReader;
import haxe.io.Bytes;
import artifacts.Artifact;
import artifacts.ArtifactInstance;
import creature.ICreatureSet;
import creature.StackInstance;
import herobonus.BonusSource;
import herobonus.BonusType;
import herobonus.selector.Selector.BonusSourceSelector;
import herobonus.selector.Selector.BonusTypeSelector;
import mapObjects.Bank;
import mapObjects.GObjectInstance;
import mapObjects.hero.GHeroInstance;
import mapObjects.hero.GHeroPlaceholder;
import mapObjects.misc.GArtifact;
import mapObjects.misc.GCreature;
import mapObjects.misc.GGarrison;
import mapObjects.misc.GLighthouse;
import mapObjects.misc.GMine;
import mapObjects.misc.GResource;
import mapObjects.misc.GScholar;
import mapObjects.misc.GShipyard;
import mapObjects.misc.GShrine;
import mapObjects.misc.GSignBottle;
import mapObjects.misc.GWitchHut;
import mapObjects.ObjectTemplate;
import mapObjects.pandorabox.GEvent;
import mapObjects.pandorabox.GPandoraBox;
import mapObjects.quest.GBorderGate;
import mapObjects.quest.GBorderGuard;
import mapObjects.quest.GQuestGuard;
import mapObjects.quest.GSeerHut.SeerHutRewardType;
import mapObjects.quest.GSeerHut;
import mapObjects.quest.IQuestObject;
import mapObjects.quest.Quest;
import mapObjects.town.CreGenAsCastleInfo;
import mapObjects.town.CreGenLeveledCastleInfo;
import mapObjects.town.CreGenLeveledInfo;
import mapObjects.town.GDwelling;
import mapObjects.town.GTownInstance;
import mapObjects.town.SpecObjInfo;
import mapping.CastleEvent;
import mapping.MapEvent;
import mapping.Rumor;
import mod.VLC;
import netpacks.ArtifactLocation;
import res.ResourceSet;
import res.ResType;
import mapping.EventEffect.EventEffectType;
import utils.Int3;
import utils.logicalexpression.EventExpression;
import utils.logicalexpression.Variant;

using Reflect;

class MapLoaderH3M implements IMapLoader {

    private var _stream:Bytes;

    private var mapHeader:MapHeader;
    private var map:MapBody;
    private var reader:BinaryReader;

    /** List of templates loaded from the map, used on later stage to create
	 *  objects but not needed for fully functional CMap */
    private var templates:Array<ObjectTemplate>;

    public function new(stream:Bytes) {
        _stream = stream;
        reader = new BinaryReader(stream);
    }

    public function loadMap():MapBody {
        map = new MapBody();
        mapHeader = map;
        init();
        return map;
    }

    public function loadMapHeader():MapHeader {
        mapHeader = new MapHeader();
        readHeader();
        return mapHeader;
    }

    private function init() {

        readHeader();

        map.allHeroes = [for (i in 0...map.allowedHeroes.length) new GHeroInstance()];

        readDisposedHeroes();

        readAllowedArtifacts();

        readAllowedSpellsAbilities();

        readRumors();

        readPredefinedHeroes();

        readTerrain();

        readDefInfo();

        readObjects();

        readEvents();

        map.calculateGuardingGreaturePositions();
        afterRead();
    }

    private function readHeader() {
        mapHeader.version = reader.readUInt32();
        mapHeader.areAnyPlayers = reader.readBool();
        mapHeader.height = mapHeader.width = reader.readUInt32();
        mapHeader.twoLevel = reader.readBool();
        mapHeader.name = reader.readString();
        mapHeader.description = reader.readString();
        mapHeader.difficulty = reader.readInt8();

        if(mapHeader.version != MapFormat.ROE) {
            mapHeader.levelLimit = reader.readUInt8();
        } else {
            mapHeader.levelLimit = 0;
        }

        readPlayerInfo();
        readVictoryLossConditions();
        readTeamInfo();
        readAllowedHeroes();
    }

    private function readPlayerInfo() {
        for (i in 0...mapHeader.players.length) {
            mapHeader.players[i].canHumanPlay = reader.readBool();
            mapHeader.players[i].canComputerPlay = reader.readBool();

            // If nobody can play with this player
            if(!(mapHeader.players[i].canHumanPlay || mapHeader.players[i].canComputerPlay)) {
                switch(mapHeader.version) {
                    case MapFormat.SOD | MapFormat.WOG:
                        reader.skip(13);
                    case MapFormat.AB:
                        reader.skip(12);
                    case MapFormat.ROE:
                        reader.skip(6);
                    default:
                }
                continue;
            }

            mapHeader.players[i].aiTactic = reader.readUInt8();

            if(mapHeader.version == MapFormat.SOD || mapHeader.version == MapFormat.WOG) {
                mapHeader.players[i].p7 = reader.readUInt8();
            } else {
                mapHeader.players[i].p7 = -1;
            }

            // Factions this player can choose
            var allowedFactions:Int = reader.readUInt8();
            // How many factions will be read from map
            var totalFactions:Int = GameConstants.F_NUMBER;

            if(mapHeader.version != MapFormat.ROE) {
                allowedFactions += reader.readUInt8() * 256;
            } else {
                totalFactions--; //exclude conflux for ROE
            }

            for(fact in 0...totalFactions) {
                if((allowedFactions & (1 << fact)) == 0) {
                    mapHeader.players[i].allowedFactions.remove(fact);
                }
            }

            mapHeader.players[i].isFactionRandom = reader.readBool();
            mapHeader.players[i].hasMainTown = reader.readBool();
            if(mapHeader.players[i].hasMainTown) {
                if(mapHeader.version != MapFormat.ROE) {
                    mapHeader.players[i].generateHeroAtMainTown = reader.readBool();
                    mapHeader.players[i].generateHero = reader.readBool();
                } else {
                    mapHeader.players[i].generateHeroAtMainTown = true;
                    mapHeader.players[i].generateHero = false;
                }
               mapHeader.players[i].posOfMainTown = readInt3();
            }

            mapHeader.players[i].hasRandomHero = reader.readBool();
            mapHeader.players[i].mainCustomHeroId = reader.readUInt8();

            if(mapHeader.players[i].mainCustomHeroId != 0xff) {
                mapHeader.players[i].mainCustomHeroPortrait = reader.readUInt8();
                if (mapHeader.players[i].mainCustomHeroPortrait == 0xff) {
                    mapHeader.players[i].mainCustomHeroPortrait = -1; //correct 1-byte -1 (0xff) into 4-byte -1
                }

                 mapHeader.players[i].mainCustomHeroName = reader.readString();
            } else {
                mapHeader.players[i].mainCustomHeroId = -1; //correct 1-byte -1 (0xff) into 4-byte -1
            }

            if(mapHeader.version != MapFormat.ROE) {
                mapHeader.players[i].powerPlaceholders = reader.readUInt8(); //unknown byte
                var heroCount = reader.readUInt8();
                reader.skip(3);
                for(pp in 0...heroCount) {
                    var vv = new HeroName();
                    vv.id = reader.readUInt8();
                    vv.name = reader.readString();

                    mapHeader.players[i].heroesNames.push(vv);
                }
            }
        }
    }

    private function readVictoryLossConditions() {
        mapHeader.triggeredEvents.splice(0, mapHeader.triggeredEvents.length);

        var vicCondition:VictoryConditionType = reader.readUInt8();

        var victoryCondition:EventCondition = new EventCondition(WinLoseType.STANDARD_WIN);
        var defeatCondition:EventCondition = new EventCondition(WinLoseType.DAYS_WITHOUT_TOWN);
        defeatCondition.value = 7;

        var standardVictory = new TriggeredEvent();
        standardVictory.effect.type = EventEffectType.VICTORY;
        standardVictory.effect.toOtherMessage = VLC.instance.generaltexth.allTexts[5];
        standardVictory.identifier = "standardVictory";
        standardVictory.description = ""; // TODO: display in quest window
        standardVictory.onFulfill = VLC.instance.generaltexth.allTexts[659];
	    standardVictory.trigger = new EventExpression(victoryCondition);

        var standardDefeat = new TriggeredEvent();
        standardDefeat.effect.type = EventEffectType.DEFEAT;
        standardDefeat.effect.toOtherMessage = VLC.instance.generaltexth.allTexts[8];
        standardDefeat.identifier = "standardDefeat";
        standardDefeat.description = ""; // TODO: display in quest window
        standardDefeat.onFulfill = "TBD: standardDefeat.onFulfill"; //VLC.generaltexth.allTexts[7];
    	standardDefeat.trigger = new EventExpression(defeatCondition);

        // Specific victory conditions
        if(vicCondition == VictoryConditionType.WINSTANDARD) {
            // create normal condition
            mapHeader.triggeredEvents.push(standardVictory);
            mapHeader.victoryIconIndex = 11;
            mapHeader.victoryMessage = VLC.instance.generaltexth.victoryConditions[0];
        } else {
            var specialVictory = new TriggeredEvent();
            specialVictory.effect.type = EventEffectType.VICTORY;
            specialVictory.identifier = "specialVictory";
            specialVictory.description = ""; // TODO: display in quest window

            mapHeader.victoryIconIndex = vicCondition;
            mapHeader.victoryMessage = VLC.instance.generaltexth.victoryConditions[(vicCondition:Int) + 1];

            var allowNormalVictory:Bool = reader.readBool();
            var appliesToAI:Bool = reader.readBool();

            if (allowNormalVictory) {
                var playersOnMap:Int = Lambda.count(mapHeader.players, function(info:PlayerInfo) {
                    return info.canAnyonePlay();
                });

                if (playersOnMap == 1) {
//                    logGlobal.warn("Map %s has only one player but allows normal victory?", _mapHeader.name);
                    allowNormalVictory = false; // makes sense? Not much. Works as H3? Yes!
                }
            }

            switch (vicCondition) {
                case VictoryConditionType.ARTIFACT:
                    var cond = new EventCondition(WinLoseType.HAVE_ARTIFACT);
                    cond.objectType = reader.readUInt8();
                    if (mapHeader.version != MapFormat.ROE)
                        reader.skip(1);

                    specialVictory.effect.toOtherMessage = VLC.instance.generaltexth.allTexts[281];
                    specialVictory.onFulfill = VLC.instance.generaltexth.allTexts[280];
                    specialVictory.trigger = new EventExpression(cond);

                case VictoryConditionType.GATHERTROOP:
                    var cond = new EventCondition(WinLoseType.HAVE_CREATURES);
                    cond.objectType = reader.readUInt8();
                    if (mapHeader.version != MapFormat.ROE)
                        reader.skip(1);
                    cond.value = reader.readUInt32();

                    specialVictory.effect.toOtherMessage = VLC.instance.generaltexth.allTexts[277];
                    specialVictory.onFulfill = VLC.instance.generaltexth.allTexts[276];
                    specialVictory.trigger = new EventExpression(cond);

                case VictoryConditionType.GATHERRESOURCE:
                    var cond = new EventCondition(WinLoseType.HAVE_RESOURCES);
                    cond.objectType = reader.readUInt8();
                    cond.value = reader.readUInt32();

                    specialVictory.effect.toOtherMessage = VLC.instance.generaltexth.allTexts[279];
                    specialVictory.onFulfill = VLC.instance.generaltexth.allTexts[278];
                    specialVictory.trigger = new EventExpression(cond);

                case VictoryConditionType.BUILDCITY:
                    var oper = EventExpression.getOperatorAll();
                    var cond = new EventCondition(WinLoseType.HAVE_BUILDING);
                    cond.position = readInt3();
                    cond.objectType = BuildingID.VILLAGE_HALL + reader.readUInt8();
                    oper.expressions.push(cond);
                    cond.objectType = BuildingID.FORT + reader.readUInt8();
                    oper.expressions.push(cond);

                    specialVictory.effect.toOtherMessage = VLC.instance.generaltexth.allTexts[283];
                    specialVictory.onFulfill = VLC.instance.generaltexth.allTexts[282];
                    specialVictory.trigger = new EventExpression(oper);

                case VictoryConditionType.BUILDGRAIL:
                    var cond = new EventCondition(WinLoseType.HAVE_BUILDING);
                    cond.objectType = BuildingID.GRAIL;
                    cond.position = readInt3();
                    if(cond.position.z > 2)
                        cond.position = new Int3(-1,-1,-1);

                    specialVictory.effect.toOtherMessage = VLC.instance.generaltexth.allTexts[285];
                    specialVictory.onFulfill = VLC.instance.generaltexth.allTexts[284];
                    specialVictory.trigger = new EventExpression(cond);

                case VictoryConditionType.BEATHERO:
                    var cond = new EventCondition(WinLoseType.DESTROY);
                    cond.objectType = Obj.HERO;
                    cond.position = readInt3();

                    specialVictory.effect.toOtherMessage = VLC.instance.generaltexth.allTexts[253];
                    specialVictory.onFulfill = VLC.instance.generaltexth.allTexts[252];
                    specialVictory.trigger = new EventExpression(cond);

                case VictoryConditionType.CAPTURECITY:
                    var cond = new EventCondition(WinLoseType.CONTROL);
                    cond.objectType = Obj.TOWN;
                    cond.position = readInt3();

                    specialVictory.effect.toOtherMessage = VLC.instance.generaltexth.allTexts[250];
                    specialVictory.onFulfill = VLC.instance.generaltexth.allTexts[249];
                    specialVictory.trigger = new EventExpression(cond);

                case VictoryConditionType.BEATMONSTER:
                    var cond = new EventCondition(WinLoseType.DESTROY);
                    cond.objectType = Obj.MONSTER;
                    cond.position = readInt3();

                    specialVictory.effect.toOtherMessage = VLC.instance.generaltexth.allTexts[287];
                    specialVictory.onFulfill = VLC.instance.generaltexth.allTexts[286];
                    specialVictory.trigger = new EventExpression(cond);

                case VictoryConditionType.TAKEDWELLINGS:
                    var oper = EventExpression.getOperatorAll();
                    oper.expressions.push(new EventCondition(WinLoseType.CONTROL, 0, Obj.CREATURE_GENERATOR1));
                    oper.expressions.push(new EventCondition(WinLoseType.CONTROL, 0, Obj.CREATURE_GENERATOR4));

                    specialVictory.effect.toOtherMessage = VLC.instance.generaltexth.allTexts[289];
                    specialVictory.onFulfill = VLC.instance.generaltexth.allTexts[288];
                    specialVictory.trigger = new EventExpression(oper);

                case VictoryConditionType.TAKEMINES:
                    var cond = new EventCondition(WinLoseType.CONTROL);
                    cond.objectType = Obj.MINE;

                    specialVictory.effect.toOtherMessage = VLC.instance.generaltexth.allTexts[291];
                    specialVictory.onFulfill = VLC.instance.generaltexth.allTexts[290];
                    specialVictory.trigger = new EventExpression(cond);

                case VictoryConditionType.TRANSPORTITEM:
                    var cond = new EventCondition(WinLoseType.TRANSPORT);
                    cond.objectType = reader.readUInt8();
                    cond.position = readInt3();

                    specialVictory.effect.toOtherMessage = VLC.instance.generaltexth.allTexts[293];
                    specialVictory.onFulfill = VLC.instance.generaltexth.allTexts[292];
                    specialVictory.trigger = new EventExpression(cond);

                default:
                    throw '[Error] vicCondition: vicCondition';
            }

            // if condition is human-only turn it into following construction: AllOf(human, condition)
            if (!appliesToAI) {
                var oper = EventExpression.getOperatorAll();
                var notAI = new EventCondition(WinLoseType.IS_HUMAN);
                notAI.value = 1;
                oper.expressions.push(notAI);
                oper.expressions.push(specialVictory.trigger.get());
                specialVictory.trigger = new EventExpression(oper);
            }

            // if normal victory allowed - add one more quest
            if (allowNormalVictory)
            {
                mapHeader.victoryMessage += " / ";
                mapHeader.victoryMessage += VLC.instance.generaltexth.victoryConditions[0];
                mapHeader.triggeredEvents.push(standardVictory);
            }
            mapHeader.triggeredEvents.push(specialVictory);
        }

        // Read loss conditions
        var lossCond:LossConditionType = reader.readUInt8();
        if (lossCond == LossConditionType.LOSSSTANDARD) {
            mapHeader.defeatIconIndex = 3;
            mapHeader.defeatMessage = VLC.instance.generaltexth.lossCondtions[0];
        } else {
            var specialDefeat = new TriggeredEvent();
            specialDefeat.effect.type = EventEffectType.DEFEAT;
            specialDefeat.effect.toOtherMessage = VLC.instance.generaltexth.allTexts[5];
            specialDefeat.identifier = "specialDefeat";
            specialDefeat.description = ""; // TODO: display in quest window

            mapHeader.defeatIconIndex = lossCond;
            mapHeader.defeatMessage = VLC.instance.generaltexth.lossCondtions[lossCond + 1];

            switch(lossCond) {
                case LossConditionType.LOSSCASTLE:
                    var noneOf = EventExpression.getOperatorNone();
                    var cond = new EventCondition(WinLoseType.CONTROL);
                    cond.objectType = Obj.TOWN;
                    cond.position = readInt3();

                    noneOf.expressions.push(cond);
                    specialDefeat.onFulfill = VLC.instance.generaltexth.allTexts[251];
                    specialDefeat.trigger = new EventExpression(noneOf);

                case LossConditionType.LOSSHERO:
                    var noneOf = EventExpression.getOperatorNone();
                    var cond = new EventCondition(WinLoseType.CONTROL);
                    cond.objectType = Obj.HERO;
                    cond.position = readInt3();

                    noneOf.expressions.push(cond);
                    specialDefeat.onFulfill = VLC.instance.generaltexth.allTexts[253];
                    specialDefeat.trigger = new EventExpression(noneOf);

                case LossConditionType.TIMEEXPIRES:
                    var cond = new EventCondition(WinLoseType.DAYS_PASSED);
                    cond.value = reader.readUInt16();

                    specialDefeat.onFulfill = VLC.instance.generaltexth.allTexts[254];
                    specialDefeat.trigger = new EventExpression(cond);

                default:
                    trace('Do nothing?');
            }
            // turn simple loss condition into complete one that can be evaluated later:
            // - any of :
            //   - days without town: 7
            //   - all of:
            //     - is human
            //     - (expression)

            var allOf = EventExpression.getOperatorAll();
            var isHuman = new EventCondition(WinLoseType.IS_HUMAN);
            isHuman.value = 1;

            allOf.expressions.push(isHuman);
            allOf.expressions.push(specialDefeat.trigger.get());
            specialDefeat.trigger = new EventExpression(allOf);

            mapHeader.triggeredEvents.push(specialDefeat);
        }
        mapHeader.triggeredEvents.push(standardDefeat);
    }

    private function readTeamInfo() {
        mapHeader.howManyTeams = reader.readUInt8();
        if(mapHeader.howManyTeams > 0) {
            // Teams
            for(i in 0...PlayerColor.PLAYER_LIMIT) {
                mapHeader.players[i].team = new TeamID(reader.readUInt8());
            }
        } else {
            // No alliances
            for(i in 0...PlayerColor.PLAYER_LIMIT) {
                if(mapHeader.players[i].canComputerPlay || mapHeader.players[i].canHumanPlay) {
                    mapHeader.players[i].team = new TeamID(mapHeader.howManyTeams++);
                }
            }
        }
    }

    private function readAllowedHeroes() {
        var allowedHeroesCount = VLC.instance.heroh.heroes.length;
        mapHeader.allowedHeroes = [for (i in 0...allowedHeroesCount) true];

        var bytes = mapHeader.version == MapFormat.ROE ? 16 : 20;

        readBoolBitmask(mapHeader.allowedHeroes, bytes, GameConstants.HEROES_QUANTITY, false);

        // Probably reserved for further heroes
        if((mapHeader.version:Int) > (MapFormat.ROE:Int)) {
            var placeholdersQty:Int = reader.readUInt32();

            reader.skip(placeholdersQty * 1);
        }
    }

    private function readDisposedHeroes() {
        // Reading disposed heroes (20 bytes)
        if((map.version:Int) >= (MapFormat.SOD:Int)) {
            var disp = reader.readUInt8();
            //map.disposedHeroes.resize(disp);
            for(g in 0...disp) {
                map.disposedHeroes[g].heroId = reader.readUInt8();
                map.disposedHeroes[g].portrait = reader.readUInt8();
                map.disposedHeroes[g].name = reader.readString();
                map.disposedHeroes[g].players = reader.readUInt8();
            }
        }

        //omitting NULLS
        reader.skip(31);
    }

    private function readAllowedArtifacts() {
        var globalArtifacts:Array<Artifact> = VLC.instance.arth.artifacts;

        map.allowedArtifact = [for(i in 0...globalArtifacts.length) true]; //handle new artifacts, make them allowed by default

        // Reading allowed artifacts:  17 or 18 bytes
        if(map.version != MapFormat.ROE) {
            var bytes = map.version == MapFormat.AB ? 17 : 18;

            readBoolBitmask(map.allowedArtifact, bytes, GameConstants.ARTIFACTS_QUANTITY);
        }

        // ban combo artifacts
        if (map.version == MapFormat.ROE || map.version == MapFormat.AB) {
            for(artifact in globalArtifacts) {
                // combo
                if (artifact.constituents.length > 0) {
                    map.allowedArtifact[artifact.id] = false;
                }
            }
            if (map.version == MapFormat.ROE) {
                map.allowedArtifact[ArtifactId.ARMAGEDDONS_BLADE] = false;
            }
        }

        // Messy, but needed
        for (event in map.triggeredEvents) {
            var patcher = function (cond:EventCondition) : Variant<EventCondition> {
                if (cond.condition == WinLoseType.HAVE_ARTIFACT || cond.condition == WinLoseType.TRANSPORT) {
                    map.allowedArtifact[cond.objectType] = false;
                }
                return cond;
            };

            event.trigger = event.trigger.morph(patcher);
        }
    }

    private function readAllowedSpellsAbilities() {
        // Read allowed spells, including new ones
        map.allowedSpell = [for(i in 0...VLC.instance.spellh.objects.length) true];

        // Read allowed abilities
        map.allowedAbilities = [for(i in 0...GameConstants.SKILL_QUANTITY) true];

        if((map.version:Int) >= (MapFormat.SOD:Int)) {
            // Reading allowed spells (9 bytes)
            var spell_bytes:Int = 9;
            readBoolBitmask(map.allowedSpell, spell_bytes, GameConstants.SPELLS_QUANTITY);

            // Allowed hero's abilities (4 bytes)
            var abil_bytes:Int = 4;
            readBoolBitmask(map.allowedAbilities, abil_bytes, GameConstants.SKILL_QUANTITY);
        }

        //do not generate special abilities and spells
        for (spell in VLC.instance.spellh.objects) {
            if (spell == null) continue;

            if (spell.isSpecialSpell() || spell.isCreatureAbility()) {
                map.allowedSpell[spell.id] = false;
            }
        }
    }

    private function readRumors() {
        map.rumors = [];
        var rumNr:Int = reader.readUInt32();

        for(it in 0...rumNr) {
            var ourRumor = new Rumor();
            ourRumor.name = reader.readString();
            ourRumor.text = reader.readString();
            map.rumors.push(ourRumor);
        }
    }

    private function readPredefinedHeroes() {
        switch(map.version) {
            case MapFormat.WOG | MapFormat.SOD:
                // Disposed heroes
                for(z in 0...GameConstants.HEROES_QUANTITY) {
                    var custom:Int =  reader.readUInt8();
                    if(custom == 0) continue;

                    var hero = new GHeroInstance();
                    hero.ID = Obj.HERO;
                    hero.subID = z;

                    var hasExp:Bool = reader.readBool();
                    if(hasExp) {
                        hero.exp = reader.readUInt32();
                    } else {
                        hero.exp = 0;
                    }

                    var hasSecSkills:Bool = reader.readBool();
                    if(hasSecSkills) {
                        var howMany:Int = reader.readUInt32();
                        hero.secSkills = [];
                        for(yy in 0...howMany) {
                            var secondarySkill = {skill: (reader.readUInt8():SecondarySkill), level: reader.readUInt8()};
                            hero.secSkills[yy] = secondarySkill;
                        }
                    }

                    loadArtifactsOfHero(hero);

                    var hasCustomBio:Bool = reader.readBool();
                    if(hasCustomBio) {
                        hero.biography = reader.readString();
                    }

                    // 0xFF is default, 00 male, 01 female
                    hero.sex = reader.readUInt8();

                    var hasCustomSpells:Bool = reader.readBool();
                    if(hasCustomSpells) {
                        readSpells(hero.spells);
                    }

                    var hasCustomPrimSkills:Bool = reader.readBool();
                    if(hasCustomPrimSkills) {
                        for(xx in 0...GameConstants.PRIMARY_SKILLS) {
                            hero.pushPrimSkill((xx:PrimarySkill), reader.readUInt8());
                        }
                    }
                    map.predefinedHeroes.push(hero);
                }
            case MapFormat.ROE:
            default:
        }
    }

    private function readSpells(dest:Array<SpellId>) {
        readBitmask(dest, 9, GameConstants.SPELLS_QUANTITY, false);
    }

    private function loadArtifactsOfHero(hero:GHeroInstance) {
        var artSet:Bool = reader.readBool();

        // True if artifact set is not default (hero has some artifacts)
        if(artSet) {
            if(hero.artifactSet.artifactsWorn.iterator().hasNext() || hero.artifactSet.artifactsInBackpack.length > 0) {
                // logGlobal.warn("Hero %s at %s has set artifacts twice (in map properties and on adventure map instance). Using the latter set...", hero.name, hero.pos.toString());
                hero.artifactSet.artifactsInBackpack = [];
                for(artifactWon in hero.artifactSet.artifactsWorn.keys()) {
                    hero.artifactSet.eraseArtSlot(artifactWon);
                }
            }

            for(pom in 0...16) {
                loadArtifactToSlot(hero, pom);
            }

            // misc5 art //17
            if((map.version:Int) >= (MapFormat.SOD:Int))
            {
                // assert(!hero.getArt(ArtifactPosition.MACH4));
                if(!loadArtifactToSlot(hero, ArtifactPosition.MACH4))
                {
                    // catapult by default
                    // assert(!hero.getArt(ArtifactPosition.MACH4));
                    hero.putArtifact(ArtifactPosition.MACH4, ArtifactInstance.createArtifact(map, ArtifactId.CATAPULT));
                }
            }

            loadArtifactToSlot(hero, ArtifactPosition.SPELLBOOK);

            // 19 //???what is that? gap in file or what? - it's probably fifth slot..
            if((map.version:Int) > (MapFormat.ROE:Int)) {
                loadArtifactToSlot(hero, ArtifactPosition.MISC5);
            } else {
                reader.skip(1);
            }

            // bag artifacts //20
            // number of artifacts in hero's bag
            var amount:Int = reader.readUInt16();
            for(ss in 0...amount) {
                loadArtifactToSlot(hero, GameConstants.BACKPACK_START + hero.artifactSet.artifactsInBackpack.length);
            }
        }
    }

    private function loadArtifactToSlot(hero:GHeroInstance, slot:Int):Bool {
        var artmask:Int = map.version == MapFormat.ROE ? 0xff : 0xffff;
        var aid:Int = map.version == MapFormat.ROE ? reader.readUInt8() : reader.readUInt16();

        var isArt:Bool = aid != artmask;
        if(isArt) {
            var art:Artifact = (aid:ArtifactId).toArtifact();

            if (art == null) {
                // logGlobal.warn("Invalid artifact in hero's backpack, ignoring...");
                return false;
            }

            if(art.isBig() && slot >= GameConstants.BACKPACK_START) {
                // logGlobal.warn("A big artifact (war machine) in hero's backpack, ignoring...");
                return false;
            }
            if(aid == 0 && slot == ArtifactPosition.MISC5) {
                //TODO: check how H3 handles it . art 0 in slot 18 in AB map
                // logGlobal.warn("Spellbook to MISC5 slot? Putting it spellbook place. AB format peculiarity? (format %d)", static_cast<int>(map.version));
                slot = ArtifactPosition.SPELLBOOK;
            }

            // this is needed, because some H3M maps (last scenario of ROE map) contain invalid data like misplaced artifacts
            var artifact = ArtifactInstance.createArtifact(map, aid);
            var artifactPos:ArtifactPosition = slot;
            if (artifact.canBePutAt(new ArtifactLocation(hero, artifactPos))) {
                hero.putArtifact(artifactPos, artifact);
            } else {
                // logGlobal.debug("Artifact can't be put at the specified location."); //TODO add more debugging information
            }
        }

        return isArt;
    }

    private function readTerrain() {
        map.initTerrain();

        for(a in 0...2) {
            if(a == 1 && !map.twoLevel) {
                break;
            }

            for(c in 0...map.width) {
                for(z in 0...map.height) {
                    var tile = map.getTile(z, c, a);
                    tile.terType = reader.readUInt8();
                    tile.terView = reader.readUInt8();
                    tile.riverType = reader.readUInt8();
                    tile.riverDir = reader.readUInt8();
                    tile.roadType = reader.readUInt8();
                    tile.roadDir = reader.readUInt8();
                    tile.extTileFlags = reader.readUInt8();
                    tile.blocked = ((tile.terType == TerrainType.ROCK || tile.terType == TerrainType.BORDER ) ? true : false); //underground tiles are always blocked
                    tile.visitable = false;
                }
            }
        }
    }

    private function readDefInfo() {
        var defAmount:Int = reader.readUInt32();

        templates = [];

        // Read custom defs
        for(idd in 0...defAmount) {
            var tmpl = new ObjectTemplate();
            tmpl.readMap(reader);
            templates.push(tmpl);
        }
    }

    private function readObjects() {
        var howManyObjs:Int = reader.readUInt32();
        map.objects = [];

        for(ww in 0...howManyObjs) {
            var nobj:GObjectInstance = null;

            var objPos:Int3 = readInt3();

            var defnum:Int = reader.readUInt32();
            var idToBeGiven:ObjectInstanceId = new ObjectInstanceId(map.objects.length);

            var objTempl:ObjectTemplate = templates[defnum];
//            trace(ww, objTempl.id);
            reader.skip(5);

            switch(objTempl.id) {
                case Obj.EVENT:
                    var evnt = new GEvent();
                    nobj = evnt;

                    readMessageAndGuards(evnt.message, evnt);

                    evnt.gainedExp = reader.readUInt32();
                    evnt.manaDiff = reader.readUInt32();
                    evnt.moraleDiff = reader.readInt8();
                    evnt.luckDiff = reader.readInt8();

                    readResourses(evnt.resources);

//                    evnt.primskills.resize(GameConstants.PRIMARY_SKILLS);
                    for (x in 0...4) {
                        evnt.primskills[x] = (reader.readUInt8():PrimarySkill);
                    }

                    var gabn:Int = reader.readUInt8(); // Number of gained abilities
                    for(oo in 0...gabn) {
                        evnt.abilities.push((reader.readUInt8():SecondarySkill));
                        evnt.abilityLevels.push(reader.readUInt8());
                    }

                    var gart = reader.readUInt8(); // Number of gained artifacts
                    for(oo in 0...gart) {
                        if(map.version == MapFormat.ROE) {
                            evnt.artifacts.push((reader.readUInt8():ArtifactId));
                        } else {
                            evnt.artifacts.push((reader.readUInt16():ArtifactId));
                        }
                    }

                    var gspel:Int = reader.readUInt8(); // Number of gained spells
                    for(oo in 0...gspel) {
                        evnt.spells.push((reader.readUInt8():SpellId));
                    }

                    var gcre = reader.readUInt8(); //number of gained creatures
                    readCreatureSet(evnt.creatures, gcre);

                    reader.skip(8);
                    evnt.availableFor = reader.readUInt8();
                    evnt.computerActivate = reader.readUInt8() != 0;
                    evnt.removeAfterVisit = reader.readUInt8() != 0;
                    evnt.humanActivate = true;

                    reader.skip(4);

                case Obj.HERO | Obj.RANDOM_HERO | Obj.PRISON:
                    nobj = readHero(idToBeGiven, objPos);

                case Obj.MONSTER | Obj.RANDOM_MONSTER | Obj.RANDOM_MONSTER_L1 | Obj.RANDOM_MONSTER_L2 | Obj.RANDOM_MONSTER_L3 | Obj.RANDOM_MONSTER_L4 | Obj.RANDOM_MONSTER_L5 | Obj.RANDOM_MONSTER_L6 | Obj.RANDOM_MONSTER_L7:
                    var cre = new GCreature();
                    nobj = cre;

                    if((map.version:Int) > (MapFormat.ROE:Int)) {
                        cre.identifier = reader.readUInt32();
                        map.questIdentifierToId[cre.identifier] = idToBeGiven;
                    }

                    var hlp = new StackInstance();
                    hlp.stackBasicDescriptor.count = reader.readUInt16();

                    //type will be set during initialization
                    cre.putStack(new SlotId(0), hlp);

                    cre.character = reader.readUInt8();

                    var hasMessage:Bool = reader.readBool();
                    if (hasMessage) {
                        cre.message = reader.readString();
                        readResourses(cre.resources);

                        var artID:Int;
                        if (map.version == MapFormat.ROE) {
                            artID = reader.readUInt8();
                        } else {
                            artID = reader.readUInt16();
                        }

                        if(map.version == MapFormat.ROE) {
                            if(artID != 0xff) {
                                cre.gainedArtifact = (artID:ArtifactId);
                            } else {
                                cre.gainedArtifact = ArtifactId.NONE;
                            }
                        } else {
                            if(artID != 0xffff) {
                                cre.gainedArtifact = (artID:ArtifactId);
                            } else {
                                cre.gainedArtifact = ArtifactId.NONE;
                            }
                        }
                    }
                    cre.neverFlees = reader.readUInt8() != 0;
                    cre.notGrowingTeam =reader.readUInt8() != 0;
                    reader.skip(2);

                case Obj.OCEAN_BOTTLE | Obj.SIGN:
                    var sb = new GSignBottle();
                    nobj = sb;
                    sb.message = reader.readString();
                    reader.skip(4);

                case Obj.SEER_HUT:
                    nobj = readSeerHut();

                case Obj.WITCH_HUT:
                    var wh = new GWitchHut();
                    nobj = wh;

                    // in RoE we cannot specify it - all are allowed (I hope)
                    if (map.version > MapFormat.ROE) {
                        for (i in 0...4) {
                            var c:Int = reader.readUInt8();
                            for (yy in 0...8) {
                                if (i * 8 + yy < GameConstants.SKILL_QUANTITY) {
                                    if (c == (c | Std.int(Math.pow(2, yy)))) {
                                        wh.allowedAbilities.push(i * 8 + yy);
                                    }
                                }
                            }
                        }
                            // enable new (modded) skills
                        if (wh.allowedAbilities.length != 1) {
                            for(skillID in GameConstants.SKILL_QUANTITY...VLC.instance.skillh.size()) {
                                wh.allowedAbilities.push(skillID);
                            }
                        }
                    } else {
                        // RoE map
                        for(skillID in 0...VLC.instance.skillh.size()) {
                            wh.allowedAbilities.push(skillID);
                        }
                    }
                case Obj.SCHOLAR:
                    var sch = new GScholar();
                    nobj = sch;
                    sch.bonusType = (reader.readUInt8():ScholarBonusType);
                    sch.bonusID = reader.readUInt8();
                    reader.skip(6);

                case Obj.GARRISON | Obj.GARRISON2:
                    var gar = new GGarrison();
                    nobj = gar;
                    nobj.setOwner(new PlayerColor(reader.readUInt8()));
                    reader.skip(3);
                    readCreatureSet(gar, 7);
                    if ((map.version:Int) > (MapFormat.ROE:Int)) {
                        gar.removableUnits = reader.readBool();
                    } else {
                        gar.removableUnits = true;
                    }
                    reader.skip(8);

                case Obj.ARTIFACT | Obj.RANDOM_ART | Obj.RANDOM_TREASURE_ART | Obj.RANDOM_MINOR_ART | Obj.RANDOM_MAJOR_ART | Obj.RANDOM_RELIC_ART | Obj.SPELL_SCROLL:
                    var artID:Int = ArtifactId.NONE; //random, set later
                    var spellID:Int = -1;
                    var art = new GArtifact();
                    nobj = art;

                    readMessageAndGuards(art.message, art);

                    if (objTempl.id == Obj.SPELL_SCROLL) {
                        spellID = reader.readUInt32();
                        artID = ArtifactId.SPELL_SCROLL;
                    } else if (objTempl.id == Obj.ARTIFACT) {
                        //specific artifact
                        artID = objTempl.subid;
                    }

                    art.storedArtifact = ArtifactInstance.createArtifact(map, artID, spellID);

                case Obj.RANDOM_RESOURCE | Obj.RESOURCE:
                    var res = new GResource();
                    nobj = res;

                    readMessageAndGuards(res.message, res);

                    res.amount = reader.readUInt32();
                    if(objTempl.subid == ResType.GOLD) {
                        // Gold is multiplied by 100.
                        res.amount *= 100;
                    }
                    reader.skip(4);

                case Obj.RANDOM_TOWN | Obj.TOWN:
                    nobj = readTown(objTempl.subid);

                case Obj.MINE | Obj.ABANDONED_MINE:
                    nobj = new GMine();
                    nobj.setOwner(new PlayerColor(reader.readUInt8()));
                    reader.skip(3);

                case Obj.CREATURE_GENERATOR1 | Obj.CREATURE_GENERATOR2 | Obj.CREATURE_GENERATOR3 | Obj.CREATURE_GENERATOR4:
                    nobj = new GDwelling();
                    nobj.setOwner(new PlayerColor(reader.readUInt8()));
                    reader.skip(3);

                case Obj.SHRINE_OF_MAGIC_INCANTATION | Obj.SHRINE_OF_MAGIC_GESTURE | Obj.SHRINE_OF_MAGIC_THOUGHT:
                    var shr = new GShrine();
                    nobj = shr;
                    var raw_id = reader.readUInt8();

                    if (255 == raw_id) {
                        shr.spell = SpellId.NONE;
                    } else {
                        shr.spell = (raw_id:SpellId);
                    }

                    reader.skip(3);

                case Obj.PANDORAS_BOX:
                    var box = new GPandoraBox();
                    nobj = box;
                    readMessageAndGuards(box.message, box);

                    box.gainedExp = reader.readUInt32();
                    box.manaDiff = reader.readUInt32();
                    box.moraleDiff = reader.readInt8();
                    box.luckDiff = reader.readInt8();

                    readResourses(box.resources);

//                    box.primskills.resize(GameConstants.PRIMARY_SKILLS);
                    for ( x in 0...4) {
                        box.primskills[x] = (reader.readUInt8():PrimarySkill);
                    }

                    var gabn:Int = reader.readUInt8();//number of gained abilities
                    for (oo in 0...gabn) {
                        box.abilities.push((reader.readUInt8():SecondarySkill));
                        box.abilityLevels.push(reader.readUInt8());
                    }
                    var gart:Int = reader.readUInt8(); //number of gained artifacts
                    for(oo in 0...gart) {
                        if(map.version > MapFormat.ROE) {
                            box.artifacts.push((reader.readUInt16():ArtifactId));
                        } else {
                            box.artifacts.push((reader.readUInt8():ArtifactId));
                        }
                    }
                    var gspel:Int = reader.readUInt8(); //number of gained spells
                    for(oo in 0...gspel) {
                        box.spells.push((reader.readUInt8():SpellId));
                    }
                    var gcre:Int = reader.readUInt8(); //number of gained creatures
                    readCreatureSet(box.creatures, gcre);
                    reader.skip(8);

                case Obj.GRAIL:
                    map.grailPos = objPos;
                    map.grailRadius = reader.readUInt32();
                    continue;

                case Obj.RANDOM_DWELLING | //same as castle + level range
                  Obj.RANDOM_DWELLING_LVL | //same as castle, fixed level
                  Obj.RANDOM_DWELLING_FACTION: //level range, fixed faction
                    var dwelling = new GDwelling();
                    nobj = dwelling;
                    var spec:SpecObjInfo = null;
                    switch(objTempl.id) {
                        case Obj.RANDOM_DWELLING:
                            spec = new CreGenLeveledCastleInfo();
                        case Obj.RANDOM_DWELLING_LVL:
                            spec = new CreGenAsCastleInfo();
                        case Obj.RANDOM_DWELLING_FACTION:
                            spec = new CreGenLeveledInfo();
                        default:
                            throw "Invalid random dwelling format";
                    }
                    spec.owner = dwelling;

                    nobj.setOwner(new PlayerColor(reader.readUInt32()));

                    //216 and 217
                    var castleSpec:CreGenAsCastleInfo = cast spec;
                    if (castleSpec != null) {
                        castleSpec.instanceId = "";
                        castleSpec.identifier = reader.readUInt32();
                        if(castleSpec.identifier == null) {
                            castleSpec.asCastle = false;
                            var MASK_SIZE:Int = 8;
                            var mask = [reader.readUInt8(), reader.readUInt8()];

                            castleSpec.allowedFactions = [];

                            for(i in 0...MASK_SIZE) {
                                castleSpec.allowedFactions[i] = ((mask[0] & (1 << i))>0);
                            }

                            for(i in 0...(GameConstants.F_NUMBER - MASK_SIZE)) {
                                castleSpec.allowedFactions[i+MASK_SIZE] = ((mask[1] & (1 << i))>0);
                            }
                        } else {
                            castleSpec.asCastle = true;
                        }
                    }

                    //216 and 218
                    var lvlSpec:CreGenLeveledInfo = cast spec;
                    if (lvlSpec != null) {
                        lvlSpec.minLevel = Std.int(Math.max(reader.readUInt8(), 1));
                        lvlSpec.maxLevel = Std.int(Math.min(reader.readUInt8(), 7));
                    }
                    dwelling.info = spec;

                case Obj.QUEST_GUARD:
                    var guard = new GQuestGuard();
                    readQuest(guard);
                    nobj = guard;

                case Obj.SHIPYARD:
                    nobj = new GShipyard();
                    nobj.setOwner(new PlayerColor(reader.readUInt32()));

                case Obj.HERO_PLACEHOLDER: //hero placeholder
                    var hp = new GHeroPlaceholder();
                    nobj = hp;

                    hp.setOwner(new PlayerColor(reader.readUInt8()));

                    var htid:Int = reader.readUInt8(); //hero type id
                    nobj.subID = htid;

                    if(htid == 0xff) {
                        hp.power = reader.readUInt8();
                        trace("Hero placeholder: by power at ${objPos}");
                    } else {
                        trace("Hero placeholder: ${VLC.instance.heroh.heroes[htid].name} at ${objPos}");
                        hp.power = 0;
                    }

                case Obj.BORDERGUARD:
                    nobj = new GBorderGuard();

                case Obj.BORDER_GATE:
                    nobj = new GBorderGate();

                case Obj.PYRAMID: //Pyramid of WoG object
                    if(objTempl.subid == 0) {
                        nobj = new Bank();
                    } else {
                        //WoG object
                        //TODO: possible special handling
                        nobj = new GObjectInstance();
                    }

                case Obj.LIGHTHOUSE: //Lighthouse
                    nobj = new GLighthouse();
                    nobj.tempOwner = new PlayerColor(reader.readUInt32());

                default: //any other object
                    if (VLC.instance.objtypeh.knownSubObjects(objTempl.id).indexOf(objTempl.subid) > -1) {
                        nobj = VLC.instance.objtypeh.getHandlerFor(objTempl.id, objTempl.subid).create(objTempl);
                    } else {
                        trace('Unrecognized object: ${objTempl.id}:${objTempl.subid} at ${objPos} on map ${map.name}');
                        nobj = new GObjectInstance();
                    }
            }

            nobj.pos = objPos;
            nobj.ID = objTempl.id;
            nobj.id = idToBeGiven;
            if(nobj.ID != Obj.HERO && nobj.ID != Obj.HERO_PLACEHOLDER && nobj.ID != Obj.PRISON) {
                nobj.subID = objTempl.subid;
            }
            nobj.appearance = objTempl;
            if (idToBeGiven != new ObjectInstanceId(map.objects.length)) {
                trace('[Assert] idToBeGiven == ObjectInstanceID(map.objects.length)' );
            }
            //TODO: define valid typeName and subtypeName fro H3M maps
            nobj.instanceName = 'obj_${nobj.id.getNum()}';
            map.addNewObject(nobj);
        }

        map.heroesOnMap.sort(function(a:GHeroInstance, b:GHeroInstance) {
            return a.subID < b.subID ? 1 : -1;
        });
    }

    private function readMessageAndGuards(message:String, guards:ICreatureSet) {
        var hasMessage = reader.readBool();
        if(hasMessage) {
            message = reader.readString();
            var hasGuards = reader.readBool();
            if(hasGuards)  {
                readCreatureSet(guards, 7);
            }
            reader.skip(4);
        }
    }

    private function readCreatureSet(out:ICreatureSet, number:Int) {
        var version:Bool = ((map.version:Int) > (MapFormat.ROE:Int));
        var maxID:Int = version ? 0xffff : 0xff;

        for (ir in 0...number) {
            var creID:CreatureId;
            var count:Int;

            if (version) {
                creID = new CreatureId(reader.readUInt16());
            } else {
                creID = new CreatureId(reader.readUInt8());
            }
            count = reader.readUInt16();

            // Empty slot
            if(creID == maxID) {
                continue;
            }

            var hlp = new StackInstance();
            hlp.stackBasicDescriptor.count = count;

            var creIdInt:Int = creID;
            if(creIdInt > maxID - 0xf) {
                //this will happen when random object has random army
                hlp.idRand = maxID - creIdInt - 1;
            } else {
                hlp.setTypeByCreatureId(creID);
            }

            out.putStack(new SlotId(ir), hlp);
        }

        out.validTypes(true);
    }

    private function readResourses(resources:ResourceSet) {
//        resources.resize(GameConstants::RESOURCE_QUANTITY); //needed?
        for(x in 0...7) {
            resources[x] = reader.readUInt32();
        }
    }

    private function readHero(idToBeGiven:ObjectInstanceId, initialPos:Int3) {
        var nhi = new GHeroInstance();

        if ((map.version:Int) > (MapFormat.ROE:Int)) {
            var identifier = reader.readUInt32();
            map.questIdentifierToId[identifier] = idToBeGiven;
        }

        var owner = new PlayerColor(reader.readUInt8());
        nhi.subID = reader.readUInt8();

        //assert(!nhi.getArt(ArtifactPosition.MACH4));

        //If hero of this type has been predefined, use that as a base.
        //Instance data will overwrite the predefined values where appropriate.
        for (elem in map.predefinedHeroes) {
            if(elem.subID == nhi.subID) {
                trace('Hero ${nhi.subID} will be taken from the predefined heroes list.');
                nhi = elem;
                break;
            }
        }
        nhi.setOwner(owner);

        nhi.portrait = nhi.subID;

        for (elem in map.disposedHeroes) {
            if (elem.heroId == nhi.subID) {
                nhi.name = elem.name;
                nhi.portrait = elem.portrait;
                break;
            }
        }

        var hasName = reader.readBool();
        if (hasName) {
            nhi.name = reader.readString();
        }
        if ((map.version:Int) > (MapFormat.AB:Int)) {
            var hasExp = reader.readBool();
            if(hasExp) {
                nhi.exp = reader.readUInt32();
            } else {
                nhi.exp = 0xffffffff;
            }
        } else {
            nhi.exp = reader.readUInt32();

            //0 means "not set" in <=AB maps
            if(nhi.exp == 0) {
                nhi.exp = 0xffffffff;
            }
        }

        var hasPortrait = reader.readBool();
        if (hasPortrait) {
            nhi.portrait = reader.readUInt8();
        }

        var hasSecSkills = reader.readBool();
        if (hasSecSkills) {
            if (nhi.secSkills.length > 0) {
                while (nhi.secSkills.length > 0) {
                    nhi.secSkills.pop();
                }
                //logGlobal.warn("Hero %s subID=%d has set secondary skills twice (in map properties and on adventure map instance). Using the latter set...", nhi.name, nhi.subID);
            }

            var howMany:Int = reader.readUInt32();
//            nhi.secSkills.resize(howMany);
            for(yy in 0...howMany) {
                nhi.secSkills[yy] = {skill: (reader.readUInt8():SecondarySkill), level:reader.readUInt8()};
            }
        }

        var hasGarison = reader.readBool();
        if (hasGarison) {
            readCreatureSet(nhi, 7);
        }

        nhi.formation = reader.readUInt8() != 0;
        loadArtifactsOfHero(nhi);
        nhi.patrol.patrolRadius = reader.readUInt8();
        if (nhi.patrol.patrolRadius == 0xff) {
            nhi.patrol.patrolling = false;
        } else {
            nhi.patrol.patrolling = true;
            nhi.patrol.initialPos = GHeroInstance.convertPosition(initialPos, false);
        }

        if ((map.version:Int) > (MapFormat.ROE:Int)) {
            var hasCustomBiography = reader.readBool();
            if(hasCustomBiography) {
                nhi.biography = reader.readString();
            }
            nhi.sex = reader.readUInt8();

            // Remove trash
            if (nhi.sex != 0xFF) {
                nhi.sex &= 1;
            }
        } else {
            nhi.sex = 0xFF;
        }

        // Spells
        if ((map.version:Int) > (MapFormat.AB:Int)) {
            var hasCustomSpells = reader.readBool();
            if (nhi.spells.length > 0) {
                while (nhi.spells.length > 0) {
                    nhi.spells.pop();
                }
                trace('Hero ${nhi.name} subID=${nhi.subID} has spells set twice (in map properties and on adventure map instance). Using the latter set...');
            }

            if (hasCustomSpells) {
                nhi.spells.push(SpellId.PRESET); //placeholder "preset spells"

                readSpells(nhi.spells);
            }
        } else if(map.version == MapFormat.AB) {
            //we can read one spell
            var buff:Int = reader.readUInt8();
            if(buff != 254) {
                nhi.spells.push(SpellId.PRESET); //placeholder "preset spells"
                if(buff < 254) { //255 means no spells
                    nhi.spells.push((buff:SpellId));
                }
            }
        }

        if ((map.version:Int) > (MapFormat.AB:Int)) {
            var hasCustomPrimSkills = reader.readBool();
            if (hasCustomPrimSkills) {
                var ps = nhi.bonusSystemNode.getAllBonuses(new BonusTypeSelector(BonusType.PRIMARY_SKILL).and(new BonusSourceSelector(BonusSource.HERO_BASE_SKILL)), null);
                if (ps.length > 0) {
                    trace('Hero ${nhi.name} subID=${nhi.subID} has set primary skills twice (in map properties and on adventure map instance). Using the latter set...');
                    for (b in ps) {
                        nhi.bonusSystemNode.removeBonus(b);
                    }
                }

                for (xx in 0...GameConstants.PRIMARY_SKILLS) {
                    nhi.pushPrimSkill((xx:PrimarySkill), reader.readUInt8());
                }
            }
        }
        reader.skip(16);
        return nhi;
    }

    private function readSeerHut() {
        var hut = new GSeerHut();

        if ((map.version:Int) > (MapFormat.ROE:Int)) {
            readQuest(hut);
        } else {
            //RoE
            var artID:Int = reader.readUInt8();
            if (artID != 255) {
                //not none quest
                hut.quest.m5arts.push(artID);
                hut.quest.missionType = MissionType.MISSION_ART;
            } else {
                hut.quest.missionType = MissionType.MISSION_NONE;
            }
            hut.quest.lastDay = -1; //no timeout
            hut.quest.isCustomFirst = hut.quest.isCustomNext = hut.quest.isCustomComplete = false;
        }

        if (hut.quest.missionType != null) {
            var rewardType:SeerHutRewardType = (reader.readUInt8():SeerHutRewardType);
            hut.rewardType = rewardType;
            switch(rewardType) {
                case SeerHutRewardType.EXPERIENCE:
                    hut.rVal = reader.readUInt32();

                case SeerHutRewardType.MANA_POINTS:
                    hut.rVal = reader.readUInt32();

                case SeerHutRewardType.MORALE_BONUS:
                    hut.rVal = reader.readUInt8();

                case SeerHutRewardType.LUCK_BONUS:
                    hut.rVal = reader.readUInt8();

                case SeerHutRewardType.RESOURCES:
                    hut.rID = reader.readUInt8();
                    // Only the first 3 bytes are used. Skip the 4th.
                    hut.rVal = reader.readUInt32() & 0x00ffffff;

                case SeerHutRewardType.PRIMARY_SKILL:
                    hut.rID = reader.readUInt8();
                    hut.rVal = reader.readUInt8();

                case SeerHutRewardType.SECONDARY_SKILL:
                    hut.rID = reader.readUInt8();
                    hut.rVal = reader.readUInt8();

                case SeerHutRewardType.ARTIFACT:
                    if (map.version == MapFormat.ROE) {
                        hut.rID = reader.readUInt8();
                    } else {
                        hut.rID = reader.readUInt16();
                    }

                case SeerHutRewardType.SPELL:
                    hut.rID = reader.readUInt8();

                case SeerHutRewardType.CREATURE:
                    if ((map.version:Int) > (MapFormat.ROE:Int)) {
                        hut.rID = reader.readUInt16();
                        hut.rVal = reader.readUInt16();
                    } else {
                        hut.rID = reader.readUInt8();
                        hut.rVal = reader.readUInt16();
                    }
                default:
            }
            reader.skip(2);
        } else {
            // missionType==255
            reader.skip(3);
        }

        return hut;
    }

    private function readQuest(guard:IQuestObject) {
        guard.quest.missionType = (reader.readUInt8():MissionType);

        switch(guard.quest.missionType) {
            case MissionType.MISSION_NONE:
                return;
            case MissionType.MISSION_PRIMARY_STAT:
//                guard.quest.m2stats.resize(4);
                for(x in 0...4) {
                    guard.quest.m2stats[x] = reader.readUInt8();
                }
            case MissionType.MISSION_LEVEL | MissionType.MISSION_KILL_HERO | MissionType.MISSION_KILL_CREATURE:
                guard.quest.m13489val = reader.readUInt32();
            case MissionType.MISSION_ART:
                var artNumber:Int = reader.readUInt8();
                for(yy in 0...artNumber) {
                    var artid:Int = reader.readUInt16();
                    guard.quest.m5arts.push(artid);
                    map.allowedArtifact[artid] = false; //these are unavailable for random generation
                }
            case MissionType.MISSION_ARMY:
                var typeNumber = reader.readUInt8();
                guard.quest.m6creatures = [];
                for(hh in 0...typeNumber) {
                    guard.quest.m6creatures[hh].type = VLC.instance.creh.creatures[reader.readUInt16()];
                    guard.quest.m6creatures[hh].count = reader.readUInt16();
                }
            case MissionType.MISSION_RESOURCES:
//                guard.quest.m7resources.resize(7);
                for(x in 0...7) {
                    guard.quest.m7resources[x] = reader.readUInt32();
                }
            case MissionType.MISSION_HERO | MissionType.MISSION_PLAYER:
                guard.quest.m13489val = reader.readUInt8();
            default:
        }

        var limit:Int = reader.readUInt32();
        if (limit == 0xffffffff) {
            guard.quest.lastDay = -1;
        } else {
            guard.quest.lastDay = limit;
        }
        guard.quest.firstVisitText = reader.readString();
        guard.quest.nextVisitText = reader.readString();
        guard.quest.completedText = reader.readString();
        guard.quest.isCustomFirst = guard.quest.firstVisitText.length > 0;
        guard.quest.isCustomNext = guard.quest.nextVisitText.length > 0;
        guard.quest.isCustomComplete = guard.quest.completedText.length > 0;
    }

    private function readTown(castleID:Int):GTownInstance {
        var nt = new GTownInstance();
        if (map.version > MapFormat.ROE) {
            nt.identifier = reader.readUInt32();
        }
        nt.tempOwner = new PlayerColor(reader.readUInt8());
        var hasName:Bool = reader.readBool();
        if (hasName) {
            nt.name = reader.readString();
        }

        var hasGarrison:Bool = reader.readBool();
        if (hasGarrison) {
            readCreatureSet(nt, 7);
        }
        nt.formation = reader.readUInt8() != 0;

        var hasCustomBuildings:Bool = reader.readBool();
        if (hasCustomBuildings) {
            readBitmask(nt.builtBuildings,6,48,false);

            readBitmask(nt.forbiddenBuildings,6,48,false);

            nt.builtBuildings = convertBuildings(nt.builtBuildings, castleID);
            nt.forbiddenBuildings = convertBuildings(nt.forbiddenBuildings, castleID);
        }
        // Standard buildings
        else {
            var hasFort = reader.readBool();
            if (hasFort) {
                nt.builtBuildings.push(BuildingID.FORT);
            }

            //means that set of standard building should be included
            nt.builtBuildings.push(BuildingID.DEFAULT);
        }

        if (map.version > MapFormat.ROE) {
            for (i in 0...9) {
                var c = reader.readUInt8();
                for (yy in 0...8) {
                    if (i * 8 + yy < GameConstants.SPELLS_QUANTITY) {
                        if (c == (c | Std.int(Math.pow(2, yy)))) { //add obligatory spell even if it's banned on a map (?)
                            nt.obligatorySpells.push(((i * 8 + yy):SpellId));
                        }
                    }
                }
            }
        }

        for (i in 0...9) {
            var c = reader.readUInt8();
            for (yy in 0...8) {
                var spellid:Int = i * 8 + yy;
                if (spellid < GameConstants.SPELLS_QUANTITY) {
                    if (c != (c | Std.int(Math.pow(2, yy))) && map.allowedSpell[spellid]) { //add random spell only if it's allowed on entire map
                        nt.possibleSpells.push((spellid:SpellId));
                    }
                }
            }
        }
        //add all spells from mods
        //TODO: allow customize new spells in towns
        for (i in SpellId.AFTER_LAST...VLC.instance.spellh.objects.length) {
            nt.possibleSpells.push((i:SpellId));
        }

        // Read castle events
        var numberOfEvent = reader.readUInt32();

        for (gh in 0...numberOfEvent) {
            var nce = new CastleEvent();
            nce.town = nt;
            nce.name = reader.readString();
            nce.message = reader.readString();

            readResourses(nce.resources);

            nce.players = reader.readUInt8();
            if (map.version > MapFormat.AB) {
                nce.humanAffected = reader.readUInt8() != 0;
            } else {
                nce.humanAffected = true;
            }

            nce.computerAffected = reader.readUInt8();
            nce.firstOccurence = reader.readUInt16();
            nce.nextOccurence =  reader.readUInt8();

            reader.skip(17);

            // New buildings

            readBitmask(nce.buildings,6,48,false);

            nce.buildings = convertBuildings(nce.buildings, castleID, false);

            nce.creatures = [];
            for (vv in 0...7) {
                nce.creatures[vv] = reader.readUInt16();
            }
            reader.skip(4);
            nt.events.push(nce);
        }

        if (map.version > MapFormat.AB) {
            nt.alignment = reader.readUInt8();
        }
        reader.skip(3);

        return nt;
    }

    private function convertBuildings(h3m:Array<BuildingID>, castleId:Int, addAuxiliary:Bool = true):Array<BuildingID> {
        var mapa = new Map<Int, BuildingID>();
        var ret = new Array<BuildingID>();

        // Note: this file is parsed many times.
        var config:Dynamic = FileCache.instance.getConfig("config/buildings5.json");

        var table:Array<Dynamic> = config.field("table");
        for (entry in table) {
            var town:Int = entry.field("town");

            if (town == castleId || town == -1) {
                mapa[(entry.field("h3"):Int)] = ((entry.field("vcmi"):BuildingID));
            }
        }

        for(elem in h3m) {
            if((mapa[elem]:Int) >= 0) {
                ret.push(mapa[elem]);
            }
            // horde buildings
            else if((mapa[elem]:Int) >= (-GameConstants.CREATURES_PER_TOWN)) {
                var level:Int = (mapa[elem]);

                //(-30)..(-36) - horde buildings (for game loading only), don't see other way to handle hordes in random towns
                ret.push(((level - 30):BuildingID));
            } else {
                trace('[Warning] Conversion warning: unknown building ${elem} in castle $castleId');
            }
        }

        if (addAuxiliary) {
            //village hall is always present
            ret.push(BuildingID.VILLAGE_HALL);
        }

        if (ret.indexOf(BuildingID.CITY_HALL) > -1) {
            ret.push(BuildingID.EXTRA_CITY_HALL);
        }
        if (ret.indexOf(BuildingID.TOWN_HALL) > -1) {
            ret.push(BuildingID.EXTRA_TOWN_HALL);
        }
        if (ret.indexOf(BuildingID.CAPITOL) > -1) {
            ret.push(BuildingID.EXTRA_CAPITOL);
        }

        return ret;
    }


    private function readEvents() {
        var numberOfEvents:Int = reader.readUInt32();
        for (yyoo in 0...numberOfEvents) {
            var ne = new MapEvent();
            ne.name = reader.readString();
            ne.message = reader.readString();

            readResourses(ne.resources);
            ne.players = reader.readUInt8();
            if(map.version > MapFormat.AB) {
                ne.humanAffected = reader.readUInt8() != 0;
            } else {
                ne.humanAffected = true;
            }
            ne.computerAffected = reader.readUInt8();
            ne.firstOccurence = reader.readUInt16();
            ne.nextOccurence = reader.readUInt8();

            reader.skip(17);

            map.events.push(ne);
        }
    }

    private function readBitmask<T>(dest:Array<T>, byteCount:Int, limit:Int, negate:Bool) {
        var temp:Array<Bool> = [for (i in 0...limit) true];
        readBoolBitmask(temp, byteCount, limit, negate);

        var min = Std.int(Math.min(temp.length, limit));
        for(i in 0...min) {
            if(temp[i]) {
                var value:T = cast i;
                dest.push(value);
            }
        }
    }

    function readBoolBitmask(dest:Array<Bool>, byteCount:Int, limit:Int, negate:Bool = true) {
        for(byte in 0...byteCount) {
            var mask:Int = reader.readUInt8();
            for(bit in 0...8) {
                if(byte * 8 + bit < limit) {
                    var flag:Bool = (mask & (1 << bit)) == 1;
                    if((negate && flag) || (!negate && !flag)) // FIXME: check PR388
                        dest[byte * 8 + bit] = false;
                }
            }
        }
    }

    function readInt3():Int3 {
        var int3 = new Int3(reader.readUInt8(), reader.readUInt8(), reader.readUInt8());
        return int3;
    }

    function afterRead() {
        //convert main town positions for all players to actual object position, in H3M it is position of active tile
        for (p in map.players) {
            var posOfMainTown:Int3 = p.posOfMainTown;
            if(posOfMainTown.valid() && map.isInTheMap(posOfMainTown)) {
                var t:TerrainTile = map.getTileByInt3(posOfMainTown);

                var mainTown:GObjectInstance = null;

                for (obj in t.visitableObjects)	{
                    if(obj.ID == Obj.TOWN || obj.ID == Obj.RANDOM_TOWN) {
                        mainTown = obj;
                        break;
                    }
                }

                if(mainTown == null) {
                    continue;
                }

                p.posOfMainTown = Int3.addition(posOfMainTown, mainTown.getVisitableOffset());
            }
        }
    }

}
