package mapObjects.hero;

import constants.Obj;
import mapping.MapBody;
import utils.Int3;
import constants.id.PlayerColor;
import herobonus.Bonus;
import herobonus.BonusValue;
import constants.PrimarySkill;
import herobonus.BonusSource;
import herobonus.BonusType;
import herobonus.BonusDuration;
import netpacks.ArtifactLocation;
import artifacts.ArtifactInstance;
import constants.ArtifactPosition;
import artifacts.Artifact.ArtBearer;
import artifacts.ArtifactSet;
import mapObjects.misc.GBoat;
import constants.id.ObjectInstanceId;
import constants.SecondarySkill;
import constants.SpellId;
import hero.Hero;
import mapObjects.town.GTownInstance;

class GHeroInstance extends ArmedInstance {
    public static inline var UNINITIALIZED_PORTRAIT = -1;
    public static inline var UNINITIALIZED_MANA = -1;
    public static inline var UNINITIALIZED_MOVEMENT = -1;

    //////////////////////////////////////////////////////////////////////////

    public var artifactSet(default, null) = new ArtifactSet();

    public var moveDir:Int; //format:	123
                            //  		8 4
                            //  		765
    public var isStanding:Int;
    public var tacticFormationEnabled:Int;

    //////////////////////////////////////////////////////////////////////////

    public var type:Hero;
    public var exp:Float; //experience points (originally signed int64)
    public var level:Int; //current level of hero
    public var name:String; //may be custom
    public var biography:String; //if custom
    public var portrait:Int; //may be custom
    public var mana:Int; // remaining spell points
    public var secSkills:Array<{skill:SecondarySkill, level:Int}>; //first - ID of skill, second - level of skill (1 - basic, 2 - adv., 3 - expert); if hero has ability (-1, -1) it meansthat it should have default secondary abilities
    public var movement:Int; //remaining movement points
    public var sex:Int;
    public var inTownGarrison:Bool; // if hero is in town garrison
    public var visitedTown:GTownInstance; //set if hero is visiting town or in the town garrison
//    public var commander:CommanderInstance; ToDo
    public var boat:GBoat; //set to CGBoat when sailing

    //public var artifacts:Array<CArtifact>; //hero's artifacts from bag
    //public var artifWorn:std::map<ui16,CArtifact>; //map<position,artifact_id>; positions: 0 - head; 1 - shoulders; 2 - neck; 3 - right-hand; 4 - left-hand; 5 - torso; 6 - right-ring; 7 - left-ring; 8 - feet; 9 - misc1; 10 - misc2; 11 - misc3; 12 - misc4; 13 - mach1; 14 - mach2; 15 - mach3; 16 - mach4; 17 - spellbook; 18 - misc5
    public var spells:Array<SpellId>; //known spells (spell IDs)
    public var visitedObjects:Array<ObjectInstanceId>;

    public var patrol:Patrol;

    // toh3m = true: manifest->h3m; toh3m=false: h3m->manifest
    public static function convertPosition(src:Int3, toh3m:Bool) {
        if (toh3m) {
            src.x += 1;
            return src;
        } else {
            src.x -= 1;
            return src;
        }
    }

    public function new() {
        super();

        secSkills = [];
        spells = [];
        visitedObjects = [];
        patrol = new Patrol();
    }

    public function pushPrimSkill(which:PrimarySkill, val:BonusValue):Void {
        bonusSystemNode.addNewBonus(new Bonus(BonusDuration.PERMANENT, BonusType.PRIMARY_SKILL, BonusSource.HERO_BASE_SKILL, val, id.getNum(), which));
    }

    public function putArtifact(pos:ArtifactPosition, art:ArtifactInstance):Void {
        art.putAt(new ArtifactLocation(this, pos));
    }

    public function bearerType():ArtBearer {
        return ArtBearer.HERO;
    }

    override public function afterAddToMap(map:MapBody) {
        if(ID == Obj.HERO) {
            map.heroesOnMap.push(this);
        }
    }
}