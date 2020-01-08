package mapObjects.town;

import herobonus.BonusSystemNodeType;
import herobonus.BonusSystemNode;

class TownAndVisitingHero extends BonusSystemNode {
    public function new() {
        super();

        setNodeType(BonusSystemNodeType.TOWN_AND_VISITOR);
    }
}
