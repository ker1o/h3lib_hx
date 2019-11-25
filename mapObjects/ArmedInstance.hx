package lib.mapObjects;

import lib.creature.CreatureSet;
import lib.herobonus.BonusSystemNode;
import lib.battle.BattleInfo;

class ArmedInstance extends GObjectInstance {

    public var battle:BattleInfo;

    // multiple inheritance in VCMI
    public var bonusSystemNode(default, null):BonusSystemNode;
    public var creatureSet(default, null):CreatureSet;

    public function new() {
        super();

        bonusSystemNode = new BonusSystemNode();
        creatureSet = new CreatureSet();
    }
}
