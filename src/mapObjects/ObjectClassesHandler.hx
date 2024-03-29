package mapObjects;

import filesystem.FileCache;
import constants.Obj;
import mapObjects.constructors.BankInstanceConstructor;
import mapObjects.constructors.DwellingInstanceConstructor;
import mapObjects.constructors.HeroInstanceConstructor;
import mapObjects.constructors.ObstacleConstructor;
import mapObjects.constructors.RewardableConstructor;
import mapObjects.constructors.TownInstanceConstructor;
import mapObjects.hero.GHeroInstance;
import mapObjects.hero.GHeroPlaceholder;
import mapObjects.market.GBlackMarket;
import mapObjects.market.GMarket;
import mapObjects.market.GUniversity;
import mapObjects.misc.Cartographer;
import mapObjects.misc.GArtifact;
import mapObjects.misc.GBoat;
import mapObjects.misc.GCreature;
import mapObjects.misc.GDenOfthieves;
import mapObjects.misc.GGarrison;
import mapObjects.misc.GLighthouse;
import mapObjects.misc.GMagi;
import mapObjects.misc.GMagicWell;
import mapObjects.misc.GMine;
import mapObjects.misc.GMonolith;
import mapObjects.misc.GObelisk;
import mapObjects.misc.GObservatory;
import mapObjects.misc.GResource;
import mapObjects.misc.GScholar;
import mapObjects.misc.GShipyard;
import mapObjects.misc.GShrine;
import mapObjects.misc.GSignBottle;
import mapObjects.misc.GSirens;
import mapObjects.misc.GSubterraneanGate;
import mapObjects.misc.GWhirlpool;
import mapObjects.misc.GWitchHut;
import mapObjects.pandorabox.GEvent;
import mapObjects.pandorabox.GPandoraBox;
import mapObjects.quest.GBorderGate;
import mapObjects.quest.GBorderGuard;
import mapObjects.quest.GKeymasterTent;
import mapObjects.quest.GQuestGuard;
import mapObjects.quest.GSeerHut;
import mapObjects.rewardable.GBonusingObject;
import mapObjects.rewardable.GMagicSpring;
import mapObjects.rewardable.GOnceVisitable;
import mapObjects.rewardable.GPickable;
import mapObjects.rewardable.GVisitableOPH;
import mapObjects.rewardable.GVisitableOPW;
import mapObjects.town.GDwelling;
import mapObjects.town.GTownInstance;
import mod.IHandlerBase;
import mod.ModHandler;
import mod.VLC;
import utils.JsonUtils;

using Reflect;

// in original key is a tuple {id:Int, subid:Int}
// but here is '$id-$subid' string
typedef TTemplatesContainer = Map<String, ObjectTemplate>;
typedef TObjectTypeHandler = AObjectTypeHandler;

class ObjectClassesHandler implements IHandlerBase {
    /// list of object handlers, each of them handles only one type
    private var objects:Map<Int, ObjectContainter>;

    /// map that is filled during contruction with all known handlers. Not serializeable due to usage of std::function
    private var handlerConstructors:Map<String, Void->TObjectTypeHandler>;

    /// container with H3 templates, used only during loading, no need to serialize it
    private var legacyTemplates:TTemplatesContainer;

    /// contains list of custom names for H3 objects (e.g. Dwellings), used to load H3 data
    /// format: customNames[primaryID][secondaryID] -> name
    private var customNames:Map<Int, Array<String>>;

    // FIXME: move into inheritNode?
    static function inheritNodeWithMeta(descendant:Dynamic, base:Dynamic):Void
    {
//        var oldMeta:String = descendant.meta;
        JsonUtils.inherit(descendant, base);
        //descendant.setMeta(oldMeta);
    }

    public function new() {
        handlerConstructors = new Map<String, Void->TObjectTypeHandler>();
        customNames = new Map<Int, Array<String>>();
        legacyTemplates = new TTemplatesContainer();
        objects = new Map<Int, ObjectContainter>();

        // list of all known handlers, hardcoded for now since the only way to add new objects is via C++ code
        //Note: should be in sync with registerTypesMapObjectTypes function
        setHandlerClass("configurable", RewardableConstructor);
        setHandlerClass("dwelling", DwellingInstanceConstructor);
        setHandlerClass("hero", HeroInstanceConstructor);
        setHandlerClass("town", TownInstanceConstructor);
        setHandlerClass("bank", BankInstanceConstructor);

        setHandlerClass("static", ObstacleConstructor);
        setHandlerClass("", ObstacleConstructor);

        setHandler("randomArtifact", GArtifact);
        setHandler("randomHero", GHeroInstance);
        setHandler("randomResource", GResource);
        setHandler("randomTown", GTownInstance);
        setHandler("randomMonster", GCreature);
        setHandler("randomDwelling", GDwelling);

        setHandler("generic", GObjectInstance);
        setHandler("market", GMarket);
        setHandler("cartographer", Cartographer);
        setHandler("artifact", GArtifact);
        setHandler("blackMarket", GBlackMarket);
        setHandler("boat", GBoat);
        setHandler("bonusingObject", GBonusingObject);
        setHandler("borderGate", GBorderGate);
        setHandler("borderGuard", GBorderGuard);
        setHandler("monster", GCreature);
        setHandler("denOfThieves", GDenOfthieves);
        setHandler("event", GEvent);
        setHandler("garrison", GGarrison);
        setHandler("heroPlaceholder", GHeroPlaceholder);
        setHandler("keymaster", GKeymasterTent);
        setHandler("lighthouse", GLighthouse);
        setHandler("magi", GMagi);
        setHandler("magicSpring", GMagicSpring);
        setHandler("magicWell", GMagicWell);
        setHandler("market", GMarket);
        setHandler("mine", GMine);
        setHandler("obelisk", GObelisk);
        setHandler("observatory", GObservatory);
        setHandler("onceVisitable", GOnceVisitable);
        setHandler("pandora", GPandoraBox);
        setHandler("pickable", GPickable);
        setHandler("prison", GHeroInstance);
        setHandler("questGuard", GQuestGuard);
        setHandler("resource", GResource);
        setHandler("scholar", GScholar);
        setHandler("seerHut", GSeerHut);
        setHandler("shipyard", GShipyard);
        setHandler("shrine", GShrine);
        setHandler("sign", GSignBottle);
        setHandler("siren", GSirens);
        setHandler("monolith", GMonolith);
        setHandler("subterraneanGate", GSubterraneanGate);
        setHandler("whirlpool", GWhirlpool);
        setHandler("university", GUniversity);
        setHandler("oncePerHero", GVisitableOPH);
        setHandler("oncePerWeek", GVisitableOPW);
        setHandler("witch", GWitchHut);
    }

    private inline function setHandlerClass(clsName:String, cls:Class<TObjectTypeHandler>) {
        handlerConstructors.set(clsName, function() {
            return Type.createInstance(cls, []);
        });
    }

    private inline function setHandler(clsName:String, cls:Class<Dynamic>) {
        handlerConstructors.set(clsName, function() {
            return new DefaultObjectTypeHandler(cls);
        });
    }

    public function loadObject(scope:String, name:String, data:Dynamic, index:UInt = 0) {
        var object = loadFromJson(data, ModHandler.normalizeIdentifier(scope, "core", name));
//        assert(objects[index] == nullptr); // ensure that this id was not loaded before
        if (index == 0) {
            index = object.id;
        }
        objects[index] = object;
        VLC.instance.modh.identifiers.registerObject(scope, "object", name, object.id);
    }

    private function loadFromJson(json:Dynamic, name:String):ObjectContainter {
        var obj = new ObjectContainter();
        obj.identifier = name;
        obj.name = json.field("name");
        obj.handlerName = json.field("handler");
        obj.base = json.field("base");
        obj.id = selectNextID(json.field("index"), objects, 256);
        if(json.hasField("defaultAiValue")) {
            obj.groupDefaultAiValue = json.field("defaultAiValue");
        } else {
            obj.groupDefaultAiValue = null;
        }

        var typesObj:Dynamic = json.field("types");
        for (entryKey in typesObj.fields()) {
            loadObjectEntry(entryKey, typesObj.field(entryKey), obj);
        }

        return obj;
    }

    public function loadSubObject(identifier:String, config:Dynamic, id:Int, ?subID:Null<Int>) {
        if (config == null) {
            trace("WTF???");
        }

        if (subID != null) {
            config.setField("index", subID);
        }

        inheritNodeWithMeta(config, objects.get(id).base);
        loadObjectEntry(identifier, config, objects.get(id));
    }

    private function loadObjectEntry(identifier:String, entry:Dynamic, obj:ObjectContainter) {
        if (!handlerConstructors.exists(obj.handlerName)) {
            throw 'Handler with name ${obj.handlerName} was not found!';
        }

        var convertedId:String = ModHandler.normalizeIdentifier(entry.field("meta"), "core", identifier);

        var id:Int = selectNextID(entry.field("index"), obj.subObjects, 1000);

        var handler:TObjectTypeHandler = handlerConstructors.get(obj.handlerName)();
        handler.setType(obj.id, id);
        handler.setTypeName(obj.identifier, convertedId);

        if (customNames.exists(obj.id) && customNames.get(obj.id).length > id) {
            handler.init(entry, customNames.get(obj.id)[id]);
        } else {
            handler.init(entry);
        }

        if (handler.getTemplates().length == 0) {
            var key = '${obj.id}-$id';
            var temp1 = legacyTemplates.get(key);
            if (temp1 != null) {
                handler.addTemplate(temp1);
            }
            legacyTemplates.remove(key);
        }

//        logGlobal.debug("Loaded object %s(%d)::%s(%d)", obj.identifier, obj.id, convertedId, id);
        //assert(!obj.subObjects.count(id)); // DO NOT override
        obj.subObjects[id] = handler;
        obj.subIds[convertedId] = id;
    }

    private function selectNextID(fixedID:Dynamic, map:Map<Int, Dynamic>, defaultID:Int):Int {
        if (fixedID != null && (fixedID:Int) < defaultID) {
            return (fixedID:Int); // H3M object with fixed ID
        }

        if (!map.keys().hasNext()) {
            return defaultID; // no objects loaded, keep gap for H3M objects
        }

        // not presented in the original
        //get last key
        var keysIterator = map.keys();
        var lastKey = 0;
        while (keysIterator.hasNext()) lastKey = keysIterator.next();
        if (lastKey >= defaultID) {
            return lastKey + 1; // some modded objects loaded, return next available
        }

        return defaultID; // some H3M objects loaded, first modded found
    }

    public function loadLegacyData(dataSize:Int):Array<Dynamic> {
        var ret:Array<Dynamic> = [];

        var parser:Array<Dynamic> = FileCache.instance.getConfig("DATA/OBJECTS.TXT");
        var totalNumber:Int = parser.length;

        for(i in 0...totalNumber) {
            var templ = new ObjectTemplate();
            templ.readTxt(parser[i]);
            var key = '${(templ.id:Int)}-${templ.subid}';
            legacyTemplates.set(key, templ);
        }

        var namesParser:Array<Dynamic> = FileCache.instance.getConfig("DATA/OBJNAMES.TXT");
        var ret:Array<Dynamic> = [];
        for (i in 0...256) {
            ret[i] = {name: namesParser[i]};
        }

        var cregen1Parser:Array<String> = FileCache.instance.getConfig("DATA/CRGEN1.TXT");
        customNames.set(Obj.CREATURE_GENERATOR1, []);
        for (s in cregen1Parser) {
            customNames.get(Obj.CREATURE_GENERATOR1).push(s);
        }

        var cregen4Parser:Array<String> = FileCache.instance.getConfig("DATA/CRGEN4.TXT");
        customNames.set(Obj.CREATURE_GENERATOR4, []);
        for (s in cregen4Parser) {
            customNames.get(Obj.CREATURE_GENERATOR4).push(s);
        }

        return ret;
    }

    public function getHandlerFor(type:Int, subtype:Int):TObjectTypeHandler {
        if (objects.exists(type)) {
            if (objects.get(type).subObjects.exists(subtype)) {
                return objects.get(type).subObjects.get(subtype);
            }
        }
        throw 'Failed to find object of type $type $subtype';
    }

    public function removeSubObject(id:Int, subId:Int) {
//        assert(objects.count(ID));
//        assert(objects.at(ID)->subObjects.count(subID));
        objects.get(id).subObjects.remove(subId); //TODO: cleanup string id map
    }

    public function knownSubObjects(primary:Int):Array<Int> {
        var ret = [];

        if (objects.exists(primary)) {
            var subobjects:Map<Int, Dynamic> = objects[primary].subObjects;

            for (key in subobjects.keys()) {
                ret.push(key);
            }
        }
        return ret;
    }

    public function getObjectName(type:Int, subtype:Int) {
        if (knownSubObjects(type).indexOf(subtype) > -1) {
            var name = getHandlerFor(type, subtype).getCustomName();
            if (name != null)
                return name;
        }
        return getObjectNameByType(type);
    }

    public function getObjectNameByType(type:Int) {
        if (objects.exists(type)) {
            return objects.get(type).name;
        }
        trace("Access to non existing object of type %d", type);
        return "";
    }
}
