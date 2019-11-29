package lib.mod;

using Reflect;

class ContentHandler {
    public var handlers:Map<String, ContentTypeHandler>;

    public function new() {
        handlers = new Map<String, ContentTypeHandler>();
    }

    public function init() {
        handlers.set("heroClasses", new ContentTypeHandler(VLC.instance.heroh.classes, "heroClass"));
        handlers.set("artifacts", new ContentTypeHandler(VLC.instance.arth, "artifact"));
        handlers.set("creatures", new ContentTypeHandler(VLC.instance.creh, "creature"));
        handlers.set("factions", new ContentTypeHandler(VLC.instance.townh, "faction"));
        handlers.set("objects", new ContentTypeHandler(VLC.instance.objtypeh, "object"));
        handlers.set("heroes", new ContentTypeHandler(VLC.instance.heroh, "hero"));
        handlers.set("spells", new ContentTypeHandler(VLC.instance.spellh, "spell"));
        handlers.set("skills", new ContentTypeHandler(VLC.instance.skillh, "skill"));
//        handlers.set("templates", new ContentTypeHandler(VLC.instance.tplh, "template"));
    }

    public function preloadData(mod:ModInfo) {
        var validate = false;
        preloadModData(mod.identifier, mod.config, validate);
    }

    private function preloadModData(modName:String, modConfig:Map<String, Dynamic>, validate:Bool):Bool {
        var result:Bool = true;
        for (handlerKey in handlers.keys()) {
            var handler = handlers.get(handlerKey);
            result = result && handler.preloadModData(modName, modConfig.get(handlerKey), validate);
        }
        return result;
    }

    public function load(mod:ModInfo) {
        var validate = false;
        loadMod(mod.identifier, validate);
    }

    private function loadMod(modName:String, validate:Bool):Bool {
        var result:Bool = true;
        for (handler in handlers) {
            result = result && handler.loadMod(modName, validate);
        }
        return result;

    }
}
