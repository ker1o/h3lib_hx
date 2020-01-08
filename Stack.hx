package lib;

import lib.constants.id.SlotId;
import lib.constants.id.PlayerColor;
import lib.battle.BattleHex;
import lib.creature.Creature;
import lib.creature.StackInstance;
import lib.herobonus.BonusSystemNode;

class Stack extends BonusSystemNode {
    public var base:StackInstance; //garrison slot from which stack originates (nullptr for war machines, summoned cres, etc)

    public var ID:UInt; //unique ID of stack
    public var type:Creature;
    public var baseAmount:UInt;

    public var owner:PlayerColor; //owner - player color (255 for neutrals)
    public var slot:SlotId;  //slot - position in garrison (may be 255 for neutrals/called creatures)
    public var side:UInt;
    public var initialPosition:BattleHex; //position on battlefield; -2 - keep, -3 - lower tower, -4 - upper tower

    public function new() {
        super();
    }
}
