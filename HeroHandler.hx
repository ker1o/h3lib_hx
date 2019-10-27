package lib;

import lib.mod.IHandlerBase;
import lib.hero.Hero;

class HeroHandler extends IHandlerBase {
    public var classes:HeroClassHandler;

    public var heroes:Array<Hero>;

    //default costs of going through terrains. -1 means terrain is impassable
    public var terrCosts:Array<Int>;

    /// expPerLEvel[i] is amount of exp needed to reach level i;
    /// consists of 201 values. Any higher levels require experience larger that ui64 can hold
    private var expPerLevel:Array<Int>;

    public function new() {
    }

    /// helpers for loading to apublic varhuge load functions
    private function loadHeroArmy(hero:Hero, node:Dynamic) {

    }

    private function loadHeroSkills(hero:Hero, node:Dynamic) {

    }

    private function loadHeroSpecialty(hero:Hero, node:Dynamic) {

    }

    private function loadExperience() {

    }

    private function loadBallistics() {

    }

    private function loadTerrains() {

    }

    private function loadObstacles() {

    }

}
