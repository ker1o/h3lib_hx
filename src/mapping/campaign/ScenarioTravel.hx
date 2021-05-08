package mapping.campaign;

class ScenarioTravel {
    public var whatHeroKeeps:Int; //bitfield [0] - experience, [1] - prim skills, [2] - sec skills, [3] - spells, [4] - artifacts
    public var monstersKeptByHero:Array<Int>;
    public var artifsKeptByHero:Array<Int>;

    public var startOptions:Int; //1 - start bonus, 2 - traveling hero, 3 - hero options

    public var playerColor:Int; //only for startOptions == 1

    public var bonusesToChoose:Array<TravelBonus>;

    public function new() {

    }
}