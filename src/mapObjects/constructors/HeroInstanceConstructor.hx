package mapObjects.constructors;

import mod.VLC;
import constants.id.HeroTypeId;
import hero.HeroClass;
import mapObjects.hero.GHeroInstance;
import utils.logicalexpression.LogicalExpression;

using Reflect;

class HeroInstanceConstructor extends DefaultObjectTypeHandler<GHeroInstance> {
    public var heroClass:HeroClass;
    public var filters:Map<String, LogicalExpression<HeroTypeId>>;

    private var _filtersJson:Dynamic;

    public function new() {
        super(GHeroInstance);
    }

    override public function create(objTempl:ObjectTemplate):GObjectInstance {
        var obj:GHeroInstance = createTyped(objTempl);
        obj.type = null;
        return obj;
    }

    override function initTypeData(input:Dynamic) {
        var name = input.field("heroClass");
        var meta = "core";
        VLC.instance.modh.identifiers.requestIdentifierByNodeName("heroClass", name, meta, function(index:Int) {
            heroClass = VLC.instance.heroh.classes.heroClasses[index];
        });

        _filtersJson = input.field("filters");
    }
}
