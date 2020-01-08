package mapObjects.misc;

//creatures on map
import creature.Creature.Resources;
import constants.ArtifactId;
import mapObjects.ArmedInstance;

class GCreature extends ArmedInstance {
    public var identifier:Int; //warn: UInt32; unique code for this monster (used in missions)
    public var character:Int; //character of this set of creatures (0 - the most friendly, 4 - the most hostile) => on init changed to -4 (compliant) ... 10 value (savage)
    public var message:String; //message printed for attacking hero
    public var resources:Resources; // resources given to hero that has won with monsters
    public var gainedArtifact:ArtifactId; //ID of artifact gained to hero, -1 if none
    public var neverFlees:Bool; //if true, the troops will never flee
    public var notGrowingTeam:Bool; //if true, number of units won't grow
    public var temppower:Int; //warn:UInt64; used to handle fractional stack growth for tiny stacks

    public var refusedJoining:Bool;

    public function new() {
        super();

        resources = new Resources();
    }
}

@:enum abstract Action(Int) from Int to Int {
    public var FIGHT:Int = -2;
    public var FLEE:Int = -1;
    public var JOIN_FOR_FREE:Int = 0; //values > 0 mean gold price
}

@:enum abstract Character(Int) from Int to Int {
    public var COMPLIANT = 0;
    public var FRIENDLY = 1;
    public var AGRESSIVE = 2;
    public var HOSTILE = 3;
    public var SAVAGE = 4;
}