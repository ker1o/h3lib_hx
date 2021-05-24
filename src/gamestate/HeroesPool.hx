package gamestate;

import mapObjects.hero.GHeroInstance;

class HeroesPool {
    public var heroesPool = new Map<Int, GHeroInstance>(); //[subID] - heroes available to buy; nullptr if not available
    public var pavailable = new Map<Int, Int>(); // [subid] -> which players can recruit hero (binary flags)

    public function new() {

    }
}