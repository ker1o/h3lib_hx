package mapping;

class DisposedHero {
    public var heroId:Int;
    public var portrait:Int; /// The portrait id of the hero, 0xFF is default.
    public var name:String;
    public var players:Int; /// Who can hire this hero (bitfield).

    public function new() {
        heroId = 0;
        portrait = 255;
        players = 0;
    }
}
