package hero;

import constants.SecondarySkill;
import creature.Creature;

class HeroClass {
    public var identifier:String;
    public var name:String; // translatable
    //double aggression; // not used in vcmi.
    public var faction:Int;
    public var id:Int;
    public var affinity:ClassAffinity; // affility, using EClassAffinity enum

    // default chance for hero of specific class to appear in tavern, if field "tavern" was not set
    // resulting chance = sqrt(town.chance * heroClass.chance)
    public var defaultTavernChance:Int;

    public var commander:Creature;

    public var primarySkillInitial:Array<Int>;  // initial primary skills
    public var primarySkillLowLevel:Array<Int>; // probability (%) of getting point of primary skill when getting level
    public var primarySkillHighLevel:Array<Int>;// same for high levels (> 10)

    public var secSkillProbability:Array<Int>; //probabilities of gaining secondary skills (out of 112), in id order

    public var selectionProbability:Map<Int, Int>; //probability of selection in towns

    public var imageBattleMale:String;
    public var imageBattleFemale:String;
    public var imageMapMale:String;
    public var imageMapFemale:String;

    public function new() {
        primarySkillInitial = [];
        primarySkillLowLevel = [];
        primarySkillHighLevel = [];
        secSkillProbability = [];
        selectionProbability = new Map<Int, Int>();
    }

    //picks secondary skill out from given possibilities
    public function chooseSecSkill(possibles:Array<SecondarySkill>):SecondarySkill {
        var totalProb = 0;
        for(possible in possibles) {
            totalProb += secSkillProbability[possible];
        }
        // may trigger if set contains only banned skills (0 probability)
        if (totalProb != 0) {
            var ran = Std.random(totalProb - 1);
            for (possible in possibles) {
                ran -= secSkillProbability[possible];
                if (ran < 0) {
                    return possible;
                }
            }
        }
        // FIXME: select randomly? How H3 handles such rare situation?
        return possibles[0];
    }

    public function isMagicHero() {
        return affinity == ClassAffinity.MAGIC;
    }
}
