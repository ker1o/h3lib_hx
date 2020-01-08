package skill;

import herobonus.BonusDuration;
import constants.SecondarySkill;
import herobonus.Bonus;
import herobonus.BonusSource;

class Skill {
    private var levels:Array<LevelInfo>; // bonuses provided by basic, advanced and expert level

    public var id:SecondarySkill;
    public var identifier:String;
    public var name:String; //as displayed in GUI
    public var gainChance:Array<Int>; // gainChance[0/1] = default gain chance on level-up for might/magic heroes

    public function new(id:SecondarySkill = SecondarySkill.DEFAULT, identifier:String = "default") {
        this.id = id;
        this.identifier = identifier;

        levels = [];
        for (skill in 0...StringConstants.SECONDARY_SKILLS_LEVELS.length - 1) {
            levels.push(new LevelInfo());
        }
        gainChance = [];
    }

    public function addNewBonus(b:Bonus, level:Int) {
        b.source = BonusSource.SECONDARY_SKILL;
        b.sid = id;
        b.duration = BonusDuration.PERMANENT;
        b.description = name;
        levels[level-1].effects.push(b);
    }

    public function getLevelInfoFor(level:Int) {
        return levels[level - 1];
    }
}
