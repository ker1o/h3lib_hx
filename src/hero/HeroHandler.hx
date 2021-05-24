package hero;

import filesystem.FileCache;
import constants.CreatureType;
import constants.GameConstants;
import constants.id.CreatureId;
import constants.SecondarySkill;
import constants.SecSkillLevel;
import constants.SpellId;
import hero.BallisticsLevelInfo;
import hero.Hero;
import hero.ObstacleInfo;
import herobonus.Bonus;
import herobonus.BonusDuration;
import herobonus.BonusList;
import herobonus.BonusSource;
import mod.IHandlerBase;
import mod.ModHandler;
import mod.VLC;
import utils.JsonUtils;

using Reflect;

class HeroHandler implements IHandlerBase {
    public var classes:HeroClassHandler;

    public var heroes:Array<Hero>;

    //default costs of going through terrains. -1 means terrain is impassable
    public var terrCosts:Array<Int>;

    public var ballistics:Array<BallisticsLevelInfo>; //info about ballistics ability per level; [0] - none; [1] - basic; [2] - adv; [3] - expert
    public var obstacles:Map<Int, ObstacleInfo>; //info about obstacles that may be placed on battlefield
    public var absoluteObstacles:Map<Int, ObstacleInfo>; //info about obstacles that may be placed on battlefield

    /// expPerLEvel[i] is amount of exp needed to reach level i;
    /// consists of 201 values. Any higher levels require experience larger that ui64 can hold
    private var expPerLevel:Array<Int>;

    public function new() {
        classes = new HeroClassHandler();
        heroes = [];

        loadObstacles();
        loadTerrains();
        for(i in 0...GameConstants.TERRAIN_TYPES) {
            VLC.instance.modh.identifiers.registerObject("core", "terrain", StringConstants.TERRAIN_NAMES[i], i);
        }
        loadBallistics();
        loadExperience();
    }

    public function loadObject(scope:String, name:String, data:Dynamic, index:Int = 0) {
        var object = loadFromJson(data, ModHandler.normalizeIdentifier(scope, "core", name));
        if (index == 0) {
            index = heroes.length;
        }
        object.ID = index;
        object.imageIndex = index;

        heroes[index] = object;
        VLC.instance.modh.identifiers.registerObject(scope, "hero", name, object.ID.getNum());
    }

    public function loadFromJson(node:Dynamic, identifier:String):Hero {
        var hero = new Hero();
        hero.identifier = identifier;
        hero.sex = node.field("female");
        hero.special = node.field("special");

        hero.name        = node.field("texts").field("name");
        hero.biography   = node.field("texts").field("biography");
        hero.specName    = node.field("texts").field("specialty").field("name");
        hero.specTooltip = node.field("texts").field("specialty").field("tooltip");
        hero.specDescr   = node.field("texts").field("specialty").field("description");

        hero.iconSpecSmall = node.field("images").field("specialtySmall");
        hero.iconSpecLarge = node.field("images").field("specialtyLarge");
        hero.portraitSmall = node.field("images").field("small");
        hero.portraitLarge = node.field("images").field("large");
        hero.battleImage = node.field("battleImage");

        loadHeroArmy(hero, node);
        loadHeroSkills(hero, node);
        loadHeroSpecialty(hero, node);

        VLC.instance.modh.identifiers.requestIdentifierByNodeName("heroClass", node.field("class"), "core", function(classID:Int) {
            hero.heroClass = classes.heroClasses[classID];
        });

        return hero;
   }

    /// helpers for loading to apublic varhuge load functions
    private function loadHeroArmy(hero:Hero, node:Dynamic) {
        hero.initialArmy = [];
        var armyObjsArr:Array<Dynamic> = node.field("army");

        for (i in 0...armyObjsArr.length) {
            var source:Dynamic = armyObjsArr[i];
            var initialArmyStack = new InitialArmyStack();
            initialArmyStack.minAmount = (source.field("min"):UInt);
            initialArmyStack.maxAmount = (source.field("max"):UInt);
            hero.initialArmy[i] = initialArmyStack;

            VLC.instance.modh.identifiers.requestIdentifierByNodeName("creature", source.field("creature"), "core", function(creature:Int) {
                hero.initialArmy[i].creature = new CreatureId((creature:CreatureType));
            });
        }
    }

    private function loadHeroSkills(hero:Hero, node:Dynamic) {
        hero.secSkillsInit = [];
        var skillsObjsArr:Array<Dynamic> = node.field("skills");
        for(set in skillsObjsArr) {
            var skillLevel:Int = StringConstants.SECONDARY_SKILLS_LEVELS.indexOf(set.field("level"));
            if (skillLevel < SecSkillLevel.LEVELS_SIZE) {
                var currentIndex:Int = hero.secSkillsInit.length;
                hero.secSkillsInit.push({skill: (-1:SecondarySkill), level: skillLevel});

                VLC.instance.modh.identifiers.requestIdentifierByNodeName("skill", set.field("skill"), "core", function(id:Int) {
                    hero.secSkillsInit[currentIndex].skill = (id:SecondarySkill);
                });
            } else {
                trace('Unknown skill level: ${set.field("level")}');
            }
        }

        // spellbook is considered present if hero have "spellbook" entry even when this is an empty set (0 spells)
        hero.haveSpellBook = node.field("spellbook") != null;

        hero.spells = [];
        if(hero.haveSpellBook) {
            var spellbookObjsArr:Array<Dynamic> = node.field("spellbook");
            for(spell in spellbookObjsArr) {
                VLC.instance.modh.identifiers.requestIdentifierByNodeName("spell", spell, "core", function(spellId:Int) {
                    hero.spells.push((spellId:SpellId));
                });
            }
        }
    }

    private function loadHeroSpecialty(hero:Hero, node:Dynamic) {
        var sid:Int = hero.ID.getNum();
        var prepSpec = function(bonus:Bonus) {
            bonus.duration = BonusDuration.PERMANENT;
            bonus.source = BonusSource.HERO_SPECIAL;
            bonus.sid = sid;
            return bonus;
        };

        //deprecated, used only for original specialties
        hero.specDeprecated = [];
        var specialtiesNode:Array<Dynamic> = node.field("specialties");
        if (specialtiesNode != null) {
            //logMod->warn("Hero %s has deprecated specialties format.", hero->identifier);
            for (specialty in specialtiesNode) {
                var spec = new SpecialtyInfo();
                spec.type = (specialty.field("type"):Int);
                spec.val = (specialty.field("val"):Int);
                spec.subtype = (specialty.field("subtype"):Int);
                spec.additionalinfo = (specialty.field("info"):Int);
                //we convert after loading completes, to have all identifiers for json logging
                hero.specDeprecated.push(spec);
            }
        }

        hero.specialtyDeprecated = [];
        hero.specialty = new BonusList();
        //new(er) format, using bonus system
        var specialtyNode:Dynamic = node.field("specialty");
        if(Std.is(specialtyNode, Array)) {
            var nodes:Array<Dynamic> = cast specialtyNode;
            //deprecated middle-aged format
            for(specialty in nodes) {
                var hs = new SpecialtyBonus();
                hs.growsWithLevel = (specialty.field("growsWithLevel"):Bool);
                hs.bonuses = new BonusList();
                var bonusesDynArray:Array<Dynamic> = specialty.field("bonuses");
                for (bonus in bonusesDynArray) {
                    hs.bonuses.push(prepSpec(JsonUtils.parseBonus(bonus)));
                }
                hero.specialtyDeprecated.push(hs);
            }
        } else {
                //creature specialty - alias for simplicity
            if(specialtyNode.field("creature") != null) {
                VLC.instance.modh.identifiers.requestIdentifierByNodeName("creature", specialtyNode.field("creature"), "core", function(creature:Int) {
                    // use legacy format for delayed conversion (must have all creature data loaded, also for upgrades)
                    var spec = new SpecialtyInfo();
                    spec.type = 1;
                    spec.additionalinfo = creature;
                    hero.specDeprecated.push(spec);
                });
            }
            var bonusesObj:Dynamic = specialtyNode.field("bonuses");
            if(bonusesObj != null) {
                //proper new format
                //ToDo: rewrite it?
                for(keyValue in bonusesObj.fields()) {
                    hero.specialty.push(prepSpec(JsonUtils.parseBonus(bonusesObj.field(keyValue))));
                }
            }
        }
    }

    private function loadExperience() {
        expPerLevel = [
            0,
            1000,
            2000,
            3200,
            4600,
            6200,
            8000,
            10000,
            12200,
            14700,
            17500,
            20600,
            24320,
            28784,
            34140
        ];

        var l = expPerLevel.length;
        for (i in l...GameConstants.MAX_HERO_LEVEL)
        {
            var i:Int = expPerLevel.length - 1;
            var diff:Int = expPerLevel[i] - expPerLevel[i-1];
            diff += Std.int(diff / 5);
            expPerLevel.push(expPerLevel[i] + diff);
        }
    }

    private function loadBallistics() {
        ballistics = [];

        var ballisticsRawData:Array<Array<Int>> = FileCache.instance.getConfig("DATA/BALLIST.TXT");

        for(levelData in ballisticsRawData) {
            var bli = new BallisticsLevelInfo();
            bli.keep   = levelData[0];
            bli.tower  = levelData[1];
            bli.gate   = levelData[2];
            bli.wall   = levelData[3];
            bli.shots  = levelData[4];
            bli.noDmg  = levelData[5];
            bli.oneDmg = levelData[6];
            bli.twoDmg = levelData[7];
            bli.sum    = levelData[8];
            ballistics.push(bli);
        }
    }

    private function loadTerrains() {
        var config:Dynamic = FileCache.instance.getConfig("config/terrains.json");
        terrCosts = [];
        for(name in StringConstants.TERRAIN_NAMES) {
            terrCosts.push(config.field(name).field("moveCost"));
        }
    }

    private function loadObstacles() {
        function local_loadObstacles(node:Array<Dynamic>, absolute:Bool):Map<Int, ObstacleInfo> {
            var out = new Map<Int, ObstacleInfo>();
            for(obs in node) {
                var id = obs.field("id");
                var obi = new ObstacleInfo();
                obi.ID = id;
                obi.defName = obs.field("defname");
                obi.width = obs.field("width");
                obi.height = obs.field("height");
                obi.allowedTerrains = obs.field("allowedTerrain"); //ToDo: convertTo array of TerrainType
                obi.allowedSpecialBfields = obs.field("specialBattlefields"); //ToDo: convertTo array of BFieldType;
                obi.blockedTiles = obs.field("blockedTiles"); //ToDo: convertTo array of Int;
                obi.isAbsoluteObstacle = absolute;
                out.set(id, obi);
            }
            return out;
        }

        var config:Dynamic = FileCache.instance.getConfig("config/obstacles.json");
        obstacles = local_loadObstacles(config.field("obstacles"), false);
        absoluteObstacles = local_loadObstacles(config.field("absoluteObstacles"), true);
    }

    public function loadLegacyData(dataSize:Int):Array<Dynamic> {
        var h3Data:Array<Dynamic> = [];
        var specParser = FileCache.instance.getConfig("DATA/HEROSPEC.TXT");
        var bioParser = FileCache.instance.getConfig("DATA/HEROBIOS.TXT");
        var parser = FileCache.instance.getConfig("DATA/HOTRAITS.TXT");

        for(i in 0...GameConstants.HEROES_QUANTITY) {
            var parserData:Dynamic = parser[i];
            var heroData:HeroData = {
                texts: {
                    name: parserData[0],
                    biography: bioParser[i],
                    speciality: {
                        name: specParser[i][0],
                        tooltip: specParser[i][1],
                        description: specParser[i][2]
                    }
                },
                army: []
            };

            for(x in 0...3) {
                var index = 1 + x * 3;
                var heroArmy:HeroArmyData = {
                    min: parserData[index],
                    max: parserData[index + 1],
                    creature: genRefName(parserData[index + 2])
                };
                heroData.army.push(heroArmy);
            }
            h3Data.push(heroData);
        }
        return h3Data;
    }

    // convert h3-style ID (e.g. Gobin Wolf Rider) to vcmi (e.g. goblinWolfRider)
    static function genRefName(input:String) {
        input = StringTools.replace(input, " ", ""); //remove spaces
        input = input.charAt(0).toLowerCase() + input.substr(1); // to camelCase
        return input;
    }

    public function reqExp(level:Int) {
        if(level == 0)
            return 0;

        if (level <= expPerLevel.length) {
            return expPerLevel[level-1];
        } else {
            trace("A hero has reached unsupported amount of experience");
            return expPerLevel[expPerLevel.length - 1];
        }
    }
}

typedef HeroData = {
    var texts:HeroTextsData;
    var army:Array<HeroArmyData>;
}

typedef HeroTextsData = {
    var name:String;
    var biography:String;
    var speciality:HeroSpecialityData;
}

typedef HeroSpecialityData = {
    var name:String;
    var tooltip:String;
    var description:String;
}

typedef HeroArmyData = {
    var min:Int;
    var max:Int;
    var creature:String;
}