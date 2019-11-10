package lib.mapObjects.quest;

import lib.mapObjects.hero.GHeroInstance;

//army is used when giving reward
class GSeerHut extends ArmedInstance implements IQuestObject {
    public var quest(default, null):Quest;

    public var rewardType:RewardType;
    public var rID:Int; //reward ID
    public var rVal:Int; //reward value
    public var seerName:String;

    public function new() {
        super();
    }

    public function getVisitText():Void {
    }

    public function checkQuest(hero:GHeroInstance):Bool {
        rewardType = NOTHING;
        rID = -1;
        rVal = -1;

        quest = new Quest();
        quest.lastDay = -1;
        quest.isCustomFirst = false;
        quest.isCustomNext = false;
        quest.isCustomComplete = false;
    }
}

@:enum abstract RewardType(Int) from Int to Int {
    public var NOTHING:Int = 0;
    public var EXPERIENCE:Int = 1;
    public var MANA_POINTS:Int = 2;
    public var MORALE_BONUS:Int = 3;
    public var LUCK_BONUS:Int = 4;
    public var RESOURCES:Int = 5;
    public var PRIMARY_SKILL:Int = 6;
    public var SECONDARY_SKILL:Int = 7;
    public var ARTIFACT:Int = 8;
    public var SPELL:Int = 9;
    public var CREATURE:Int = 10;
}