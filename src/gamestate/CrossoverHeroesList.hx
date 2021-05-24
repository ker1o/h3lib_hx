package gamestate;

import mapObjects.hero.GHeroInstance;

class CrossoverHeroesList {
    public var heroesFromPreviousScenario:Array<GHeroInstance>;
    public var heroesFromAnyPreviousScenarios:Array<GHeroInstance>;

    public function new() {
    }

    public function addHeroToBothLists(hero:GHeroInstance) {
        heroesFromPreviousScenario.push(hero);
        heroesFromAnyPreviousScenarios.push(hero);
    }

    public function removeHeroFromBothLists(hero:GHeroInstance) {
        heroesFromPreviousScenario.remove(hero);
        heroesFromAnyPreviousScenarios.remove(hero);
    }
}