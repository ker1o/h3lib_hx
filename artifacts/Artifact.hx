package lib.artifacts;

import constants.ArtifactId;
import constants.CreatureType;
import constants.ArtifactPosition;
import lib.herobonus.BonusSystemNode;

class Artifact extends BonusSystemNode { //container for artifacts
    public var name:String;
    public var description:String;
    public var eventText:String;

    public var identifier:String;
    public var image:String;
    public var large:String; // big image for cutom artifacts, used in drag & drop
    public var advMapDef:String; //used for adventure map object
    public var iconIndex:Int;
    public var price:Int;
    public var possibleSlots:Map<ArtBearer, Array<ArtifactPosition>>; //Bearer Type => ids of slots where artifact can be placed
    public var constituents:Array<Artifact>; // Artifacts IDs a combined artifact consists of, or nullptr.
    public var constituentOf:Array<Artifact>; // Reverse map of constituents - combined arts that include this art
    public var aClass:ArtClass;
    public var id:ArtifactId;
    public var warMachine:CreatureType;

    public function new() {
        super();
        possibleSlots = new Map<ArtBearer, Array<ArtifactPosition>>();
        constituents = [];
        constituentOf = [];
    }

    public inline function isBig():Bool {
        return warMachine != CreatureType.NONE;
    }
}

@:enum abstract ArtClass(Int) from Int to Int {
    public var ART_SPECIAL:Int = 1;
    public var ART_TREASURE:Int = 2;
    public var ART_MINOR:Int = 4;
    public var ART_MAJOR:Int = 8;
    public var ART_RELIC:Int = 16;
}

@:enum abstract ArtBearer(Int) from Int to Int {
    public var HERO:Int = 1;
    public var CREATURE:Int = 2;
    public var COMMANDER:Int = 3;
}

