package lib.mapObjects;

import lib.mapObjects.misc.GWitchHut;
import lib.mapObjects.rewardable.GVisitableOPH;
import lib.mapObjects.market.GUniversity;
import lib.mapObjects.misc.GWhirlpool;
import lib.mapObjects.misc.GSubterraneanGate;
import lib.mapObjects.misc.GMonolith;
import lib.mapObjects.misc.GSirens;
import lib.mapObjects.misc.GSignBottle;
import lib.mapObjects.misc.GShrine;
import lib.mapObjects.misc.GShipyard;
import lib.mapObjects.rewardable.GVisitableOPW;
import lib.mapObjects.quest.GSeerHut;
import lib.mapObjects.misc.GScholar;
import lib.mapObjects.quest.GQuestGuard;
import lib.mapObjects.rewardable.GPickable;
import lib.mapObjects.pandorabox.GPandoraBox;
import lib.mapObjects.rewardable.GOnceVisitable;
import lib.mapObjects.misc.GObservatory;
import lib.mapObjects.misc.GObelisk;
import lib.mapObjects.misc.GMine;
import lib.mapObjects.misc.GMagicWell;
import lib.mapObjects.rewardable.GMagicSpring;
import lib.mapObjects.misc.GMagi;
import lib.mapObjects.misc.GLighthouse;
import lib.mapObjects.quest.GKeymasterTent;
import lib.mapObjects.hero.GHeroPlaceholder;
import lib.mapObjects.misc.GGarrison;
import lib.mapObjects.pandorabox.GEvent;
import lib.mapObjects.misc.GDenOfthieves;
import lib.mapObjects.quest.GBorderGuard;
import lib.mapObjects.quest.GBorderGate;
import lib.mapObjects.rewardable.GBonusingObject;
import lib.mapObjects.constructors.BankInstanceConstructor;
import lib.mapObjects.constructors.DwellingInstanceConstructor;
import lib.mapObjects.constructors.HeroInstanceConstructor;
import lib.mapObjects.constructors.ObstacleConstructor;
import lib.mapObjects.constructors.RewardableConstructor;
import lib.mapObjects.constructors.TownInstanceConstructor;
import lib.mapObjects.hero.GHeroInstance;
import lib.mapObjects.market.GBlackMarket;
import lib.mapObjects.market.GMarket;
import lib.mapObjects.town.GDwelling;
import lib.mapObjects.town.GTownInstance;
import lib.mapObjects.misc.Cartographer;
import lib.mapObjects.misc.GArtifact;
import lib.mapObjects.misc.GBoat;
import lib.mapObjects.misc.GCreature;
import lib.mapObjects.misc.GResource;
import lib.mod.IHandlerBase;

typedef TTemplatesContainer = Map<{x:Int, y:ObjectContainter}, ObjectTemplate>;
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

    public function new() {
        handlerConstructors = new Map<String, Void->TObjectTypeHandler>();

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
    }

    public function loadLegacyData(dataSize:Int):Array<Dynamic> {
        var ret:Array<Dynamic> = null;
        //ToDo

        return ret;
    }
}
