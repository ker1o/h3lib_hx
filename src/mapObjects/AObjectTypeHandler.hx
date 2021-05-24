package mapObjects;

import mapping.TerrainType;
import constants.Obj;

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
    }

    public function init(input:Dynamic, name:String = null) {
        base = input;

        templates = [];
        //ToDo
    }

    function preInitObject(obj:GObjectInstance) {
        obj.ID = type;
        obj.subID = subtype;
        obj.typeName = typeName;
        obj.subTypeName = subTypeName;
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
}
