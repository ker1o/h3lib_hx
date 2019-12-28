package lib.skill;

import lib.herobonus.Bonus;

class LevelInfo {
    public var description:String; //descriptions of spell for skill level
    public var iconSmall:String;
    public var iconMedium:String;
    public var iconLarge:String;
    public var effects:Array<Bonus>;

    public function new() {
        effects = [];
    }
}
