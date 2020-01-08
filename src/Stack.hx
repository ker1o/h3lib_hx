package lib;

import constants.id.SlotId;
import constants.id.PlayerColor;
import battle.BattleHex;
import creature.Creature;
import creature.StackInstance;
import herobonus.BonusSystemNode;

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
