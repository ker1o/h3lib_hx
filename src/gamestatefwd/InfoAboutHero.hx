package gamestatefwd;

import hero.HeroClass;

class InfoAboutHero {
    public var details:HeroDetails;
    public var hclass:HeroClass;
    public var portrait:Int;

    public function new() {

    }
}

class HeroDetails {
    public var primskills:Array<Int> = [];
    public var mana:Int;
    public var manaLimit:Int;
    public var luck:Int;
    public var morale:Int;

    public function new() {

    }
}