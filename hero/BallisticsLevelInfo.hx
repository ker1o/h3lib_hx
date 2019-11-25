package lib.hero;

class BallisticsLevelInfo {
    //chance to hit in percent (eg. 87 is 87%)
    public var keep:Int;
    public var tower:Int;
    public var gate:Int;
    public var wall:Int;

    public var shots:Int; //how many shots we have

    //chances for shot dealing certain dmg in percent (eg. 87 is 87%); must sum to 100
    public var noDmg:Int;
    public var oneDmg:Int;
    public var twoDmg:Int;

    public var  sum:Int; //I don't know if it is useful for anything, but it's in config file

    public function new() {
    }
}
