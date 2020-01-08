package herobonus;

class HeroBonus {
    static public function retrieveStackInstance(node:BonusSystemNode) {
        switch(node.getNodeType()) {
            case BonusSystemNodeType.STACK_INSTANCE:
                return cast node;
            case BonusSystemNodeType.STACK_BATTLE:
                return cast(node, Stack).base;
            default:
                return null;
        }
    }
}
