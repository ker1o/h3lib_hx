package lib.mapObjects.town;

import lib.herobonus.BonusSystemNodeType;
import lib.herobonus.BonusSystemNode;

class TownAndVisitingHero extends BonusSystemNode {
    public function new() {
        super();

        setNodeType(BonusSystemNodeType.TOWN_AND_VISITOR);
    }
}
