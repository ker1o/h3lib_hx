package mapping;

import constants.Obj;
import mapping.MapEditManager;
import constants.id.ObjectInstanceId;
import mapObjects.misc.TeleportChannel;
import constants.id.TeleportChannelId;
import constants.id.ArtifactInstanceID;
import Array;
import artifacts.ArtifactInstance;
import mapObjects.GObjectInstance;
import mapObjects.hero.GHeroInstance;
import mapObjects.quest.Quest;
import mapObjects.town.GTownInstance;
import mapping.MapEvent;
import mapping.Rumor;
import utils.Int3;

class MapBody extends MapHeader {
    public var checksum:UInt /* UInt32 */;
    public var rumors:Array<Rumor>;
    public var disposedHeroes:Array<DisposedHero>;
    public var predefinedHeroes:Array<GHeroInstance>;
    public var allowedSpell:Array<Bool>;
    public var allowedArtifact:Array<Bool>;
    public var allowedAbilities:Array<Bool>;
    public var events:Array<MapEvent>;
    public var grailPos:Int3;
    public var grailRadius:Int;

    //Central lists of items in game. Position of item in the vectors below is their (instance) id.
    public var objects:Array<GObjectInstance>;
    public var towns:Array<GTownInstance>;
    public var artInstances:Array<ArtifactInstance>;
    public var quests:Array<Quest>;
    public var allHeroes:Array<GHeroInstance>; //indexed by [hero_type_id]; on map, disposed, prisons, etc.

    //Helper lists
    public var heroesOnMap:Array<GHeroInstance>;
    public var teleportChannels:Map<TeleportChannelId, TeleportChannel>;

    public var questIdentifierToId:Map<Int, ObjectInstanceId>;
    public var editManager:MapEditManager;
    public var guardingCreaturePositions:Array<Array<Array<Int3>>>;
    public var instanceNames:Map<String, GObjectInstance>;

    private var _terrain:Array<Array<Array<TerrainTile>>>;

    public function new() {
        super();

        rumors = [];
        disposedHeroes = [];
        predefinedHeroes = [];
        allowedSpell = [];
        allowedArtifact = [];
        allowedAbilities = [];
        events = [];

        objects = [];
        towns = [];
        artInstances = [];
        quests = [];
        allHeroes = [];

        heroesOnMap = [];
        questIdentifierToId = new Map<Int, ObjectInstanceId>();
        teleportChannels = new Map<TeleportChannelId, TeleportChannel>();
        instanceNames = new Map<String, GObjectInstance>();
    }

    public function initTerrain() {
        var level = twoLevel ? 2 : 1;
        _terrain = [];
        guardingCreaturePositions = [];
        for(i in 0...width) {
            _terrain[i] = [];
            guardingCreaturePositions[i] = []; // height
            for(j in 0...height) {
                _terrain[i][j] = new Array<TerrainTile>(); //level
                guardingCreaturePositions[i][j] = new Array<Int3>();
                for(l in 0...level) {
                    _terrain[i][j][l] = new TerrainTile();
                    guardingCreaturePositions[i][j][l] = new Int3();
                }
            }
        }
    }

    public inline function isInTheMap(pos:Int3) {
        // if not out the borders
        return !(pos.x < 0 || pos.y < 0 || pos.z < 0 || pos.x >= width || pos.y >= height || pos.z > (twoLevel ? 1 : 0));
    }

    public inline function getTile(x:Int, y:Int, z:Int):TerrainTile {
        return _terrain[x][y][z];
    }

    public inline function getTileByInt3(pos:Int3):TerrainTile {
        return _terrain[pos.x][pos.y][pos.z];
    }

    public function addNewArtifactInstance(art:ArtifactInstance) {
        art.id = new ArtifactInstanceID(artInstances.length);
        artInstances.push(art);
    }

    public function addNewQuestInstance(quest:Quest) {
        quest.qid = quests.length;
        quests.push(quest);
    }

    public function calculateGuardingGreaturePositions() {
        var levels:Int = twoLevel ? 2 : 1;
        for (i in 0...width) {
            for(j in 0...height) {
                for (k in 0...levels) {
                    guardingCreaturePositions[i][j][k] = guardingCreaturePosition(new Int3(i, j, k));
                }
            }
        }
    }

    public function guardingCreaturePosition(pos:Int3) {
        var originalPos:Int3 = pos;
        // Give monster at position priority.
        if (!isInTheMap(pos)) {
            return new Int3(-1, -1, -1);
        }
        var posTile:TerrainTile = getTileByInt3(pos);
        if (posTile.visitable) {
            for (obj in posTile.visitableObjects) {
                if(obj.blockVisit) {
                    if (obj.ID == Obj.MONSTER) // Monster
                        return pos;
                    else
                        return new Int3(-1, -1, -1); //blockvis objects are not guarded by neighbouring creatures
                }
            }
        }

        // See if there are any monsters adjacent.
        var water:Bool = posTile.isWater();

        pos.addComponents(-1, -1, 0); // Start with top left.
        for (dx in 0...3) {
            for (dy in 0...3) {
                if (isInTheMap(pos)) {
                    var tile = getTileByInt3(pos);
                    if (tile.visitable && (tile.isWater() == water)) {
                        for (obj in tile.visitableObjects) {
                            if (obj.ID == Obj.MONSTER  &&  checkForVisitableDir(pos, posTile, originalPos)) { // Monster being able to attack investigated tile
                                return pos;
                            }
                        }
                    }
                }

                pos.y++;
            }
            pos.y -= 3;
            pos.x++;
        }

        return new Int3(-1, -1, -1);
    }

    public function checkForVisitableDir(src:Int3, pom:TerrainTile, dst:Int3):Bool {
        if (!pom.entrableTerrainTile()) { //rock is never accessible
            return false;
        }

        for (obj in pom.visitableObjects) { //checking destination tile
            if (pom.blockingObjects.indexOf(obj) == -1) {//this visitable object is not blocking, ignore
                continue;
            }

            if (!obj.appearance.isVisitableFrom(src.x - dst.x, src.y - dst.y)) {
                return false;
            }
        }
        return true;
    }

    public function addNewObject(obj:GObjectInstance) {
        var it = instanceNames.get(obj.instanceName);
        if(it != null)
            throw 'Object instance name duplicated: ${obj.instanceName}';

        objects.push(obj);
        instanceNames[obj.instanceName] = obj;
        addBlockVisTiles(obj);

        obj.afterAddToMap(this);
    }

    public function addBlockVisTiles(obj:GObjectInstance) {
        for (fx in 0...obj.getWidth()) {
            for (fy in 0...obj.getHeight()) {
                var xVal:Int = obj.pos.x - fx;
                var yVal:Int = obj.pos.y - fy;
                var zVal:Int = obj.pos.z;
                if (xVal >= 0 && xVal < width && yVal >= 0 && yVal < height) {
                    var curt:TerrainTile = _terrain[xVal][yVal][zVal];
                    if (obj.visitableAt(xVal, yVal)) {
                        curt.visitableObjects.push(obj);
                        curt.visitable = true;
                    }
                    if (obj.blockingAt(xVal, yVal)) {
                        curt.blockingObjects.push(obj);
                        curt.blocked = true;
                    }
                }
            }
        }
    }

    public function removeBlockVisTiles(obj:GObjectInstance, total:Bool) {
        for (fx in 0...obj.getWidth()) {
            for(fy in 0...obj.getHeight()) {
                var xVal = obj.pos.x - fx;
                var yVal = obj.pos.y - fy;
                var zVal = obj.pos.z;
                if (xVal >= 0 && xVal < width && yVal >= 0 && yVal < height) {
                    var curt:TerrainTile = _terrain[xVal][yVal][zVal];
                    if(total || obj.visitableAt(xVal, yVal)) {
                        curt.visitableObjects.remove(obj);
                        curt.visitable = curt.visitableObjects.length > 0;
                    }
                    if(total || obj.blockingAt(xVal, yVal)) {
                        curt.blockingObjects.remove(obj);
                        curt.blocked = curt.blockingObjects.length > 0;
                    }
                }
            }
        }
    }

    public function getEditManager() {
        if (editManager == null) {
            editManager = new MapEditManager(this);
        }
        return editManager;
    }
}
