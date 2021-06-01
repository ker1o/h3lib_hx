package mapObjects;

import utils.JsonUtils;
import mapping.TerrainType;
import constants.Obj;

using Reflect;

class AObjectTypeHandler {
    public var typeName:String;
    public var subTypeName:String;
    public var type:Int;
    public var subtype:Int;

    private var rmgInfo:RandomMapInfo;
    /// Human-private var name:readable private var this:of object, private var for:used private var like:objects private var and:banks dwellings, private var set:if
    private var objectName:String;
    private var base:Dynamic; /// private var base:describes template
    private var templates:Array<ObjectTemplate>;
    private var sounds:ObjectSounds;
    private var aiValue:Null<Int>;

    public function new() {
        type = -1;
        subtype = -1;

        rmgInfo = new RandomMapInfo();
        sounds = new ObjectSounds();
    }

    public function init(input:Dynamic, name:String = null) {
        templates = [];

        base = input.field("base");

        if (input.hasField("rmg")) {
            var rmg:Dynamic = input.field("rmg");
            rmgInfo.value =     rmg.field("value");
            rmgInfo.mapLimit =  loadJsonOrMax(rmg, "mapLimit");
            rmgInfo.zoneLimit = loadJsonOrMax(rmg, "zoneLimit");
            rmgInfo.rarity =    rmg.field("rarity");
        } // else block is not needed - set in constructor

        var templatesObj:Array<String> = input.field("templates");
        var templateField = templatesObj.fields();
        for (entryName in templateField) {
            var entry = templatesObj.field(entryName);
            JsonUtils.inherit(entry, base);

            var tmpl = new ObjectTemplate();
            tmpl.id = (type:Obj);
            tmpl.subid = subtype;
            tmpl.stringID = entryName; // FIXME: create "fullID" - type.object.template?
            tmpl.readJson(entry);
            templates.push(tmpl);
        }

        if (!input.hasField("name")) {
            objectName = name;
        } else {
            objectName = input.field("name");
        }

        var ambientSounds:Array<Dynamic> = input.field("sounds").field("ambient");
        if (ambientSounds != null) {
            for (node in ambientSounds) {
                sounds.ambient.push(Std.string(node));
            }
        }

        var visitSounds:Array<Dynamic> = input.field("sounds").field("visit");
        if (visitSounds != null) {
            for (node in visitSounds)
                sounds.visit.push(Std.string(node));
        }

        var removalSounds:Array<Dynamic> = input.field("sounds").field("removal");
        if (removalSounds != null) {
            for(node in removalSounds) {
                sounds.removal.push(Std.string(node));
            }
        }

        if (!input.hasField("aiValue")) {
            aiValue = null;
        } else {
            aiValue = (input.field("aiValue"):Int);
        }

        initTypeData(input);
    }

    function preInitObject(obj:GObjectInstance) {
        obj.ID = type;
        obj.subID = subtype;
        obj.typeName = typeName;
        obj.subTypeName = subTypeName;
    }

    function initTypeData(input:Dynamic) {
        // empty implementation for overrides
    }

    public function setType(type:Int, subtype:Int) {
        this.type = type;
        this.subtype = subtype;
    }

    public function setTypeName(type:String, subtype:String) {
        this.typeName = type;
        this.subTypeName = subtype;
    }

    public function getTemplates():Array<ObjectTemplate> {
        return templates;
    }

    public function getTemplatesForTerrain(terrainType:Int) {
        var templates:Array<ObjectTemplate> = getTemplates();
        var filtered:Array<ObjectTemplate> = [];

        for (template in templates) {
            if (template.canBePlacedAt((terrainType:TerrainType))) {
                filtered.push(template);
            }
        };
            // H3 defines allowed terrains in a weird way - artifacts, monsters and resources have faulty masks here
            // Perhaps we should re-define faulty templates and remove this workaround (already done for resources)
        if (type == Obj.ARTIFACT || type == Obj.MONSTER) {
            return templates;
        } else {
            return filtered;
        }
    }

    public function addTemplate(templ:ObjectTemplate) {
        templ.id = (type:Obj);
        templ.subid = subtype;
        templates.push(templ);
    }

    /// Creates object and set up core properties (like ID/subID). Object is NOT initialized
    /// to allow creating objects before game start (e.g. map loading)
    public function create(objTempl:ObjectTemplate):GObjectInstance {
        throw "AObjectTypeHandler.create() must be overriden";
    }

    public function getCustomName() {
        return objectName;
    }

    static function loadJsonOrMax(obj:Dynamic, name:String):Int {
        return obj.hasField(name) ? obj.field(name) : 2147483647;
    }
}
