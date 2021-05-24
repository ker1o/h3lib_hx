package playerstate;

import constants.PlayerStatus;
import creature.Creature.Resources;
import mapObjects.town.GDwelling;
import mapObjects.town.GTownInstance;
import mapObjects.hero.GHeroInstance;
import constants.id.ObjectInstanceId;
import constants.id.PlayerColor;
import mapping.TeamID;
import herobonus.BonusSystemNode;

class PlayerState extends BonusSystemNode {
    public var color:PlayerColor;
    public var human:Bool; //true if human controlled player, false for AI
    public var team:TeamID;
    public var resources:Resources;
    public var visitedObjects:Array<ObjectInstanceId>; // as a std::set, since most accesses here will be from visited status checks
    public var heroes:Array<GHeroInstance>;
    public var towns:Array<GTownInstance>;
    public var availableHeroes:Array<GHeroInstance>; //heroes available in taverns
    public var dwellings:Array<GDwelling>; //used for town growth
//    public var quests:Array<QuestInfo>; //store info about all received quests

    public var enteredWinningCheatCode:Bool;
    public var enteredLosingCheatCode:Bool; //if true, this player has entered cheat codes for loss / victory
    public var status:PlayerStatus;
    public var daysWithoutCastle:Int;

    public function new() {
        super();

    }
}