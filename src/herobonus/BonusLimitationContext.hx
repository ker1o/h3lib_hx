package herobonus;

class BonusLimitationContext {
    public var b:Bonus;
    public var node:BonusSystemNode;
    public var alreadyAccepted:BonusList;
    public var stillUndecided:BonusList;

    public function new(b:Bonus, node:BonusSystemNode, alreadyAccepted:BonusList, stillUndecided:BonusList) {
        this.b = b;
        this.node = node;
        this.alreadyAccepted = alreadyAccepted;
        this.stillUndecided = stillUndecided;
    }
}
