package spells;

import herobonus.Bonus;

class LevelInfo {
    public var description:String; //descriptions of spell for skill level
    public var cost:Int;
    public var power:Int;
    public var AIValue:Int;

    public var smartTarget:Bool;
    public var clearTarget:Bool;
    public var clearAffected:Bool;
    public var range:String;

    //TODO: remove these two when AI will understand special effects
    public var effects:Array<Bonus>; //deprecated
    public var cumulativeEffects:Array<Bonus>; //deprecated

    public var battleEffects:Dynamic;

    public function new() {
        effects = [];
        cumulativeEffects = [];
    }
}
