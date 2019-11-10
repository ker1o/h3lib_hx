package lib.mapObjects.quest;

import lib.creature.StackBasicDescriptor;

class Quest {
    public var qid:Int; //unique quest id for serialization / identification

    public var missionType:Mission;
    public var progress:Progress;
    public var lastDay:Int; //after this day (first day is 0) mission cannot be completed ; if -1 - no limit

    public var m13489val:UInt;
    public var m2stats:Array<UInt>;
    public var m5arts:Array<UInt>; //artifacts id
    public var m6creatures:Array<StackBasicDescriptor>; //pair[cre id, cre count], CreatureSet info irrelevant
    public var m7resources:Array<UInt>; //TODO: use resourceset?

    // following fields are used only for kill creature/hero missions, the original
    // objects became inaccessible after their removal, so we need to store info
    // needed for messages / hover text
    public var textOption:UInt;
    public var completedOption:UInt;
    public var stackToKill:StackBasicDescriptor;
    public var stackDirection:UInt;
    public var heroName:String; //backup of hero name
    public var heroPortrait:Int;

    public var firstVisitText:String;
    public var nextVisitText:String;
    public var completedText:String;
    public var isCustomFirst:Bool;
    public var isCustomNext:Bool;
    public var isCustomComplete:Bool;

    public function new() {
        qid = -1;
        missionType = MISSION_NONE;
        progress = NOT_ACTIVE;
        lastDay = -1;
        m13489val = 0;

        textOption = 0;
        completedOption = 0;
        stackDirection = 0;
        heroPortrait = -1;

        isCustomFirst = false;
        isCustomNext = false;
        isCustomComplete = false;
    }
}

@:enum abstract Mission(Int) from Int to Int {
    public var MISSION_NONE:Int = 0;
    public var MISSION_LEVEL:Int = 1;
    public var MISSION_PRIMARY_STAT:Int = 2;
    public var MISSION_KILL_HERO:Int = 3;
    public var MISSION_KILL_CREATURE:Int = 4;
    public var MISSION_ART:Int = 5;
    public var MISSION_ARMY:Int = 6;
    public var MISSION_RESOURCES:Int = 7;
    public var MISSION_HERO:Int = 8;
    public var MISSION_PLAYER:Int = 9;
    public var MISSION_KEYMASTER:Int = 10;
}

@:enum abstract Progress(Int) from Int to Int {
    public var NOT_ACTIVE:Int = 0;
    public var IN_PROGRESS:Int = 1;
    public var COMPLETE:Int = 2;
}