package lib.mod;

class ContentHandler {
    public var handlers:Map<String, ContentTypeHandler>;

    public function new() {
        handlers = new Map<String, ContentTypeHandler>();
    }

    public function init() {
        handlers.set("heroClasses", new ContentTypeHandler(VLC.instance.heroh, "heroClass"));
    }
}
