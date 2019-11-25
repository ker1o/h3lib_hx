package lib.hero;

import constants.id.CreatureId;
import constants.CreatureType;
import lib.mod.ModHandler;
import haxe.Json;
import haxe.Json;
import constants.GameConstants;
import data.ConfigData;
import data.H3mConfigData;
import lib.hero.BallisticsLevelInfo;
import lib.hero.Hero;
import lib.hero.ObstacleInfo;
import lib.mod.IHandlerBase;
import lib.mod.VLC;

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

        VLC.instance.modh.identifiers.requestIdentifier("heroClass", node.field("class"), "core", function(classID:Int) {
            hero.heroClass = classes.heroClasses[classID];
        });

        return hero;
   }

    /// helpers for loading to apublic varhuge load functions
    private function loadHeroArmy(hero:Hero, node:Dynamic) {
        hero.initialArmy = [];
        var armyObjsArr:Array<Dynamic> = node.field("army");

        for (i in 0...armyObjsArr.length) {
            var source = armyObjsArr[i];
            var initialArmyStack = new InitialArmyStack();
            initialArmyStack.minAmount = (source.field("min"):UInt);
            initialArmyStack.maxAmount = (source.field("max"):UInt);
            hero.initialArmy[i] = initialArmyStack;

            VLC.instance.modh.identifiers.requestIdentifier("creature", source.field("creature"), "core", function(creature:Int) {
                hero.initialArmy[i].creature = new CreatureId((creature:CreatureType));
            });
        }
    }

    private function loadHeroSkills(hero:Hero, node:Dynamic) {

    }

    private function loadHeroSpecialty(hero:Hero, node:Dynamic) {

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

        var ballisticsRawData:Array<Array<Int>> = Json.parse(H3mConfigData.data.get("DATA/BALLIST.TXT"));

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
        var config:Dynamic = Json.parse(ConfigData.data.get("config/terrains.json"));
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

        var config:Dynamic = Json.parse(ConfigData.data.get("config/obstacles.json"));
        obstacles = local_loadObstacles(config.field("obstacles"), false);
        absoluteObstacles = local_loadObstacles(config.field("absoluteObstacles"), true);
    }

    public function loadLegacyData(dataSize:Int):Array<Dynamic> {
        heroes = [];
        var h3Data:Array<Dynamic> = [];
        var specParser = Json.parse(H3mConfigData.data.get("DATA/HEROSPEC.TXT"));
        var bioParser = Json.parse(H3mConfigData.data.get("DATA/HEROBIOS.TXT"));
        var parser = Json.parse(H3mConfigData.data.get("DATA/HOTRAITS.TXT"));

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
                    creature: parserData[index + 2]
                };
                heroData.army.push(heroArmy);
            }
            h3Data.push(heroData);
        }
        return h3Data;
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