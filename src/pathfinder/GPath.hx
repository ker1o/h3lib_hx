package pathfinder;

import mapObjects.hero.GHeroInstance;
import utils.Int3;

@:forward(length)
abstract GPath(Array<PathNode>) {
    public function new() {
        this = [];
    }

    public function startPos():Int3 {
        return this[this.length - 1].coord;
    }

    public function endPos() {
        return this[0].coord;
    }

    public function convert(mode:Int) {
        if (mode == 0) {
            for (elem in this) {
                elem.coord = GHeroInstance.convertPosition(elem.coord, true);
            }
        }
    }

}