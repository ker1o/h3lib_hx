package creature;

import herobonus.BonusSystemNode;
import constants.id.CreatureId;
import herobonus.Bonus;
import constants.ArtifactId;
import constants.CreatureType;
import herobonus.BonusDuration;
import herobonus.BonusSource;
import herobonus.BonusSystemNode;
import herobonus.BonusSystemNodeType;
import herobonus.BonusType;
import herobonus.BonusValue;
import res.ResourceSet;

typedef Resources = ResourceSet;

class Creature extends BonusSystemNode {
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
        super();

        animation = new CreatureAnimation();
        sounds = new CreatureBattleSounds();
        upgrades = new Array<CreatureType>();

        setNodeType(BonusSystemNodeType.CREATURE);
        faction = 0;
        level = 0;
        fightValue = AIValue = growth = hordeGrowth = ammMin = ammMax = 0;
        doubleWide = false;
        special = true;
        iconIndex = -1;
    }

    public function addBonus(val:Int, type:BonusType, subtype:Int = -1):Void {
        var added = new Bonus(BonusDuration.PERMANENT, type, BonusSource.CREATURE_ABILITY, val, idNumber, subtype, BonusValue.BASE_NUMBER);
        addNewBonus(added);
    }

    public function isMyUpgrade(anotherCreature:Creature):Bool {
        return upgrades.indexOf(anotherCreature.idNumber) > -1;
    }

    public function setId(id:CreatureId) {
        idNumber = id;
        for(bonus in getExportedBonusList()) {
            if(bonus.source == BonusSource.CREATURE_ABILITY) {
                bonus.sid = id;
            }
        }
        BonusSystemNode.treeHasChanged();
    }

    public static function getQuantityID(quantity:Int) {
        if (quantity<5)
            return 1;
        if (quantity<10)
            return 2;
        if (quantity<20)
            return 3;
        if (quantity<50)
            return 4;
        if (quantity<100)
            return 5;
        if (quantity<250)
            return 6;
        if (quantity<500)
            return 7;
        if (quantity<1000)
            return 8;
        return 9;
    }
}
