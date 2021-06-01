package mapObjects.quest;

import utils.Int3;
import mapObjects.misc.GCreature;
import mapObjects.quest.Quest.MissionType;
import constants.id.SlotId;
import mapping.MapBody;
import mapObjects.hero.GHeroInstance;

//army is used when giving reward
class GSeerHut extends ArmedInstance implements IQuestObject {
    public var quest(default, null):Quest;

    public var rewardType:SeerHutRewardType;
    public var rID:Int; //reward ID
    public var rVal:Int; //reward value
    public var seerName:String;

    public function new() {
        super();

        rewardType = NOTHING;
        rID = -1;
        rVal = -1;

        quest = new Quest();
        quest.lastDay = -1;
        quest.isCustomFirst = false;
        quest.isCustomNext = false;
        quest.isCustomComplete = false;
    }

    public function getVisitText():Void {
        //ToDo
    }

    public function checkQuest(hero:GHeroInstance):Bool {
        return quest.checkQuest(hero);
    }

    override public function afterAddToMap(map:MapBody) {
        map.addNewQuestInstance(quest);
    }

    public function setObjToKill() {
        if(quest.missionType == MissionType.MISSION_KILL_CREATURE) {
            //FIXME: stacks tend to disappear (desync?) on server :?
            quest.stackToKill = getCreatureToKill(false).getStack(new SlotId(0)).stackBasicDescriptor;
            //assert(quest.stackToKill.type);
            quest.stackToKill.count = 0; //no count in info window
            quest.stackDirection = checkDirection();
        } else if(quest.missionType == MissionType.MISSION_KILL_HERO) {
            quest.heroName = getHeroToKill(false).name;
            quest.heroPortrait = getHeroToKill(false).portrait;
        }
    }

    function getCreatureToKill(allowNull:Bool = false) {
        var o:GObjectInstance = GObjectInstance.cb.getObjByQuestIdentifier(quest.m13489val);
        if (allowNull && o == null)
            return null;
        //assert(o && o.ID == Obj.MONSTER);
        return cast(o, GCreature);
    }

    function checkDirection() {
        var cord:Int3 = getCreatureToKill().pos;
        var cb = GObjectInstance.cb;
        if (cord.x/cb.getMapSize().x < 0.34) {//north
            if (cord.y/cb.getMapSize().y < 0.34) //northwest
                return 8;
            else if (cord.y/cb.getMapSize().y < 0.67) //north
                return 1;
            else //northeast
                return 2;
        } else if (cord.x/cb.getMapSize().x < 0.67) {//horizontal
            if (cord.y/cb.getMapSize().y < 0.34) //west
                return 7;
            else if (cord.y/cb.getMapSize().y < 0.67) //central
                return 9;
            else //east
                return 3;
        } else {//south
            if (cord.y/cb.getMapSize().y < 0.34) //southwest
                return 6;
            else if (cord.y/cb.getMapSize().y < 0.67) //south
                return 5;
            else //southeast
                return 4;
        }
    }

    function getHeroToKill(allowNull:Bool) {
        var o:GObjectInstance = GObjectInstance.cb.getObjByQuestIdentifier(quest.m13489val);
        if (allowNull && o == null)
            return null;
        //assert(o && (o.ID == Obj.HERO  ||  o.ID == Obj.PRISON));
        return cast(o, GHeroInstance);
    }
}

@:enum abstract SeerHutRewardType(Int) from Int to Int {
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