package lib.spells;

class TargetInfo {
    public var type:AimType;
    public var smart:Bool;
    public var massive:Bool;
    public var clearAffected:Bool;
    public var clearTarget:Bool;    
    
    public function new(spell:Spell, level:Int, mode:Mode) {
        type = spell.getTargetType();
        smart = false;
        massive = false;
        clearAffected = false;
        clearTarget = false;
    }
}
