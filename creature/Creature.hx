package lib.creature;

import constants.ArtifactId;
import constants.CreatureType;
import lib.res.ResourceSet;

typedef Resources = ResourceSet;

class Creature {
    public var identifier:String;

    public var nameRef:String; // reference name, stringID
    public var nameSing:String;// singular name, e.g. Centaur
    public var namePl:String;  // plural name, e.g. Centaurs

    public var abilityText:String; //description of abilities

    public var idNumber:CreatureType;
    public var faction:Int;
    public var level:Int; // 0 - unknown; 1-7 for "usual" creatures

    //stats that are not handled by bonus system
    public var fightValue:Int;
    public var AIValue:Int;
    public var growth:Int;
    public var hordeGrowth:Int;
    public var ammMin:Int; // initial size of stack of these creatures on adventure map (if not set in editor)
    public var ammMax:Int;
    public var doubleWide:Bool;
    public var special:Bool; // Creature is not available normally (war machines, commanders, several unused creatures, etc

    public var cost:Resources; //cost[res_id] - amount of that resource required to buy creature from dwelling
    public var upgrades:Array<CreatureType>; // [originally a set] IDs of creatures to which this creature can be upgraded

    public var animDefName:String; // creature animation used during battles
    public var advMapDef:String; //for new creatures only, image for adventure map
    public var iconIndex:Int; // index of icon in files like twcrport

    /// names of files with appropriate icons. Used only during loading
    public var smallIconName:String;
    public var largeIconName:String;

    public var animation:CreatureAnimation;
    public var sounds:CreatureBattleSounds;

    public var warMachine:ArtifactId;

    public function new() {
    }
}
