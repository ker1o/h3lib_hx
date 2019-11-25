package lib.mod;

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
}
