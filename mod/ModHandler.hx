package lib.mod;

class ModHandler {

    public var identifiers:IdentifierStorage;
    public var content:ContentHandler;


    public var settings:HardcodedFeatures;
    public var modules: {
        var STACK_EXP:Bool;
        var STACK_ARTIFACT:Bool;
        var COMMANDERS:Bool;
        var MITHRIL:Bool;
    };

    public function new() {
        settings = new HardcodedFeatures();
        modules = {
            STACK_EXPERIENCE: false,
            STACK_ARTIFACTS: false,
            COMMANDERS: false,
            MITHRIL: false //so far unused
        };

        content = new ContentHandler();
    }

    public function load() {
        content.init();
    }
}
