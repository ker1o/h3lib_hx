package netpacks;

import herobonus.Bonus;

class GiveBonus {
//    enum {HERO, PLAYER, TOWN};
    public var who:Int; //who receives bonus, uses enum above
    public var id:Int; //hero. town or player id - whoever receives it
    public var bonus:Bonus;
    public var bdescr:MetaString;

    public function new(who:Int) {
        this.who = who;
        id = 0;
    }
}