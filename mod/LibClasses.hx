package lib.mod;

class LibClasses {
    public var heroh:HeroHandler;

    public var modh:ModHandler;

    public function new() {
        heroh = new HeroHandler();
    }

    public function loadFilesystem() {
        modh = new ModHandler();
    }

    public function init() {
        modh.load();
    }
}
