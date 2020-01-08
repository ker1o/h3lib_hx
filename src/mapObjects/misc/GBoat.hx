package mapObjects.misc;

import mapObjects.hero.GHeroInstance;

class GBoat extends GObjectInstance {
    public var direction:Int;
    public var hero:GHeroInstance;  //hero on board

    public function new() {
        super();

        hero = null;
        direction = 4;
    }
}
