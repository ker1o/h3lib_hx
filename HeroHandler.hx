package lib;

import constants.GameConstants;
import data.ConfigData;
import data.H3mConfigData;
import lib.hero.BallisticsLevelInfo;
import lib.hero.Hero;
import lib.hero.ObstacleInfo;
import lib.mod.IHandlerBase;
import lib.mod.VLC;

class HeroHandler extends IHandlerBase {
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
        VLC.instance.heroh = this;
        loadObstacles();
        loadTerrains();
        for(i in 0...GameConstants.TERRAIN_TYPES) {
            VLC.instance.modh.identifiers.registerStorage("core", "terrain", StringConstants.TERRAIN_NAMES[i], i)
        }
        loadBallistics();
        loadExperience();
    }

    /// helpers for loading to apublic varhuge load functions
    private function loadHeroArmy(hero:Hero, node:Dynamic) {

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

        while (expPerLevel[expPerLevel.length - 1] > expPerLevel[expPerLevel.length - 2])
        {
            var i:Int = expPerLevel.length - 1;
            var diff:Int = expPerLevel[i] - expPerLevel[i-1];
            diff += Std.int(diff / 5);
            expPerLevel.push(expPerLevel[i] + diff);
        }
        expPerLevel.pop();//last value is broken
    }

    private function loadBallistics() {
        ballistics = [];

        var ballisticsRawData = H3mConfigData.data.get("DATA/BALLIST.TXT");

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
        var config = ConfigData.data.get("config/terrains.json");
        terrCosts = [];
        for(name in StringConstants.TERRAIN_NAMES) {
            terrCosts.push(config[name]["moveCost"]);
        }
    }

    private function loadObstacles() {
        function local_loadObstacles(node:Dynamic, absolute:Bool):Map<Int, ObstacleInfo> {
            var out = new Map<Int, ObstacleInfo>();
            for(obs in (node:Array<Dynamic>)) {
                var id = obs["id"];
                var obi = new ObstacleInfo();
                obi.ID = id;
                obi.defName = obs["defname"];
                obi.width = obs["width"];
                obi.height = obs["height"];
                obi.allowedTerrains = obs["allowedTerrain"]; //ToDo: convertTo array of TerrainType
                obi.allowedSpecialBfields = obs["specialBattlefields"]; //ToDo: convertTo array of BFieldType;
                obi.blockedTiles = obs["blockedTiles"]; //ToDo: convertTo array of Int;
                obi.isAbsoluteObstacle = absolute;
                out[id] = obi;
            }
            return out;
        }

        var config = ConfigData.data.get("config/obstacles.json");
        obstacles = local_loadObstacles(config["obstacles"], false);
        absoluteObstacles = local_loadObstacles(config["absoluteObstacles"], true);
    }


    override public function loadLegacyData(dataSize:Int):Array<Dynamic> {

    }
}
