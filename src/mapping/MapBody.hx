package mapping;

import utils.logicalexpression.Variant;
import mod.VLC;
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

using StringTools;

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

    public function removeBlockVisTiles(obj:GObjectInstance, total:Bool = false) {
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

    public function checkForObjectives() {
        // NOTE: probably should be moved to MapFormatH3M.cpp
        for (event in triggeredEvents) {
            var patcher = function(cond:EventCondition):Variant<EventCondition> {
                switch (cond.condition) {
                    case WinLoseType.HAVE_ARTIFACT:
                        event.onFulfill.replace("%s", VLC.instance.arth.artifacts[cond.objectType].name);

                    case WinLoseType.HAVE_CREATURES:
                        event.onFulfill.replace("%s", VLC.instance.creh.creatures[cond.objectType].nameSing);
                        event.onFulfill.replace("%d", Std.string(cond.value));

                    case WinLoseType.HAVE_RESOURCES:
                        event.onFulfill.replace("%s", VLC.instance.generaltexth.restypes[cond.objectType]);
                        event.onFulfill.replace("%d", Std.string(cond.value));

                    case WinLoseType.HAVE_BUILDING:
                        if (isInTheMap(cond.position)) {
                            cond.object = getObjectiveObjectFrom(cond.position, Obj.TOWN);
                        }

                    case WinLoseType.CONTROL:
                        if (isInTheMap(cond.position)) {
                            cond.object = getObjectiveObjectFrom(cond.position, (cond.objectType:Obj));
                        }

                        if (cond.object != null) {
                            var town:GTownInstance = cast(cond.object, GTownInstance);
                            if (town != null)
                                event.onFulfill.replace("%s", town.name);
                            var hero:GHeroInstance = cast(cond.object, GHeroInstance);
                            if (hero != null)
                                event.onFulfill.replace("%s", hero.name);
                        }

                    case WinLoseType.DESTROY:
                        if (isInTheMap(cond.position)) {
                            cond.object = getObjectiveObjectFrom(cond.position, (cond.objectType:Obj));
                        }

                        if (cond.object) {
                            var hero = cast(cond.object, GHeroInstance);
                            if (hero != null) {
                                event.onFulfill.replace("%s", hero.name);
                            }
                        }
                    case WinLoseType.TRANSPORT:
                        cond.object = getObjectiveObjectFrom(cond.position, Obj.TOWN);
                    default:
                }
                return cond;
            };
            event.trigger = event.trigger.morph(patcher);
        }
    }

    function getObjectiveObjectFrom(pos:Int3, type:Obj):GObjectInstance	{
        for (object in getTileByInt3(pos).visitableObjects) {
            if (object.ID == type) {
                return object;
            }
        }
        // There is weird bug because of which sometimes heroes will not be found properly despite having correct position
        // Try to workaround that and find closest object that we can use

    //	logGlobal.error("Failed to find object of type %d at %s", int(type), pos.toString());
    //	logGlobal.error("Will try to find closest matching object");

        var bestMatch:GObjectInstance = null;
        for (object in objects) {
            if (object != null && object.ID == type) {
                if (bestMatch == null) {
                    bestMatch = object;
                } else {
                    if (object.pos.dist2dSQ(pos) < bestMatch.pos.dist2dSQ(pos)) {
                        bestMatch = object;// closer than one we already found
                    }
                }
            }
        }
        //assert(bestMatch != null); // if this happens - victory conditions or map itself is very, very broken

        //logGlobal.error("Will use %s from %s", bestMatch.getObjectName(), bestMatch.pos.toString());
        return bestMatch;
    }
}
