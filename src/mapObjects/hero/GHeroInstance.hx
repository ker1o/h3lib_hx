package mapObjects.hero;

import herobonus.BonusSystemNode;
import constants.id.HeroTypeId;
import creature.CommanderInstance;
import constants.SecSkillLevel;
import utils.Utils;
import constants.id.SlotId;
import artifacts.Artifact;
import creature.IArmyDescriptor;
import herobonus.selector.Selector.BonusSelector;
import constants.ArtifactId;
import mod.VLC;
import constants.GameConstants;
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
    public var isStanding:Bool;
    public var tacticFormationEnabled:Int;

    //////////////////////////////////////////////////////////////////////////

    public var type:Hero;
    public var exp:Int; //experience points (originally signed int64)
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
    public var commander:CommanderInstance;
    public var boat:GBoat; //set to CGBoat when sailing

    //public var artifacts:Array<CArtifact>; //hero's artifacts from bag
    //public var artifWorn:std.map<ui16,CArtifact>; //map<position,artifact_id>; positions: 0 - head; 1 - shoulders; 2 - neck; 3 - right-hand; 4 - left-hand; 5 - torso; 6 - right-ring; 7 - left-ring; 8 - feet; 9 - misc1; 10 - misc2; 11 - misc3; 12 - misc4; 13 - mach1; 14 - mach2; 15 - mach3; 16 - mach4; 17 - spellbook; 18 - misc5
    public var spells:Array<SpellId>; //known spells (spell IDs)
    public var visitedObjects:Array<ObjectInstanceId>;

    public var patrol:Patrol;
    public var skillsInfo:SecondarySkillsInfo;

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
        skillsInfo = new SecondarySkillsInfo();

        artifactSet.bearerType = bearerType;
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

    public function getHeroStrength() {
        return Math.sqrt(Math.pow(getFightingStrength(), 2.0) * Math.pow(getMagicStrength(), 2.0));
    }

    public function getFightingStrength():Float {
        return Math.sqrt((1.0 + 0.05 * bonusSystemNode.getPrimSkillLevel(PrimarySkill.ATTACK)) * (1.0 + 0.05 * bonusSystemNode.getPrimSkillLevel(PrimarySkill.DEFENSE)));
    }

    public function getMagicStrength() {
        return Math.sqrt((1.0 + 0.05 * bonusSystemNode.getPrimSkillLevel(PrimarySkill.KNOWLEDGE)) * (1.0 + 0.05 * bonusSystemNode.getPrimSkillLevel(PrimarySkill.SPELL_POWER)));
    }

    public function copy():GHeroInstance {
        throw "Implement GHeroInstance.copy()!";
    }

    public function initHeroWithType(subid:HeroTypeId) {
        this.subID = subid.getNum();
        initHero();
    }

    public function initHero() {
        if(type == null)
            type = VLC.instance.heroh.heroes[subID];

        if (ID == Obj.HERO)
            appearance = VLC.instance.objtypeh.getHandlerFor(Obj.HERO, type.heroClass.id).getTemplates()[0];

        if(spells.indexOf(SpellId.PRESET) == -1) {//hero starts with a spell
            for(spellID in type.spells) {
                spells.push(spellID);
            }
        } else {//remove placeholder
            spells.remove(SpellId.PRESET);
        }

        if (artifactSet.getArt(ArtifactPosition.MACH4) == null && artifactSet.getArt(ArtifactPosition.SPELLBOOK) == null && type.haveSpellBook) //no catapult means we haven't read pre-existent set . use default rules for spellbook
            putArtifact(ArtifactPosition.SPELLBOOK, ArtifactInstance.createNewArtifactInstanceById(ArtifactId.SPELLBOOK));

        if (artifactSet.getArt(ArtifactPosition.MACH4) == null)
            putArtifact(ArtifactPosition.MACH4, ArtifactInstance.createNewArtifactInstanceById(ArtifactId.CATAPULT)); //everyone has a catapult

        if (portrait < 0 || portrait == 255)
            portrait = type.imageIndex;

        if (!bonusSystemNode.hasBonus(BonusSelector.getSourceSelector(BonusSource.HERO_BASE_SKILL))) {
            for(g in 0...GameConstants.PRIMARY_SKILLS) {
                pushPrimSkill(cast(g, PrimarySkill), type.heroClass.primarySkillInitial[g]);
            }
        }

        if(secSkills.length == 1 && secSkills[0].skill == SecondarySkill.DEFAULT && secSkills[0].level == -1) //set secondary skills to default
            secSkills = type.secSkillsInit;

        if (name == null)
            name = type.name;

        if (sex == 0xFF)//sex is default
            sex = type.sex;

        formation = false;
        if (!stacks.iterator().hasNext()) {//standard army//initial army
            initArmy();
        }
//        assert(validTypes());

        if(exp == 0xffffffff) {
            initExp();
        } else {
            levelUpAutomatically();
        }

        if (VLC.instance.modh.modules.COMMANDERS && commander == null) {
            commander = new CommanderInstance(type.heroClass.commander.idNumber);
            commander.setArmyObj(this); //TODO: separate function for setting commanders
            commander.giveStackExp(exp); //after our exp is set
        }

        if (mana < 0)
            mana = bonusSystemNode.manaLimit();
    }

    public function initArmy(dst:IArmyDescriptor = null) {
        if (dst == null)
            dst = this._creatureSet;

        var howManyStacks = 0; //how many stacks will hero receives <1 - 3>
        var pom = Std.random(99);
        var warMachinesGiven = 0;

        if (pom < 9) {
            howManyStacks = 1;
        } else if(pom < 79) {
            howManyStacks = 2;
        } else {
            howManyStacks = 3;
        }

        howManyStacks = cast Math.min(howManyStacks, type.initialArmy.length);

        for (stackNo in 0...howManyStacks) {
            var stack = type.initialArmy[stackNo];

            var count = stack.minAmount + Std.random(stack.maxAmount - stack.minAmount);

            var creature = stack.creature.toCreature();

            if(creature == null) {
                //logGlobal.error("Hero %s has invalid creature with id %d in initial army", name, stack.creature.toEnum());
                continue;
            }

            if(creature.warMachine != ArtifactId.NONE) {//war machine
                warMachinesGiven++;
                if (dst != this._creatureSet)
                    continue;

                var aid:ArtifactId = creature.warMachine;
                var art:Artifact = aid.toArtifact();

                if(art != null && art.possibleSlots.get(ArtBearer.HERO).iterator().hasNext()) {
                    //TODO: should we try another possible slots?
                    var slot:ArtifactPosition = art.possibleSlots.get(ArtBearer.HERO)[0];

                    if (artifactSet.getArt(slot) == null) {
                        putArtifact(slot, ArtifactInstance.createNewArtifactInstanceById(aid));
                    } else {
                        trace('Hero $name already has artifact at $slot, omitting giving artifact $aid');
                    }
                } else {
                    trace('Hero $name has invalid war machine in initial army');
                }
            } else {
                dst.setCreature(new SlotId(stackNo - warMachinesGiven), stack.creature, count);
            }
        }
    }

    function initExp() {
        exp = 40 + Std.random(89 - 40);
    }

    function levelUpAutomatically() {
        while (gainsLevel()) {
            var primarySkill = nextPrimarySkill();
            setPrimarySkill(primarySkill, 1, 0);

            var proposedSecondarySkills = getLevelUpProposedSecondarySkills();

            var secondarySkill = nextSecondarySkill();
            if (secondarySkill != null) {
                setSecSkillLevel(secondarySkill, 1, false);
            }

            //TODO why has the secondary skills to be passed to the method?
            levelUp(proposedSecondarySkills);
        }
    }

    function gainsLevel() {
        return exp >= VLC.instance.heroh.reqExp(level+1);
    }

    function nextPrimarySkill() {
        //assert(gainsLevel());
        var randomValue = Std.random(99);
        var pom = 0;
        var primarySkill = 0;
        var skillChances = (level > 9) ? type.heroClass.primarySkillLowLevel : type.heroClass.primarySkillHighLevel;

        while(primarySkill < GameConstants.PRIMARY_SKILLS)
        {
            pom += skillChances[primarySkill];
            if(randomValue < pom) {
                break;
            }
            primarySkill++;
        }

        trace('The hero gets the primary skill $primarySkill with a probability of $randomValue.');
        return cast(primarySkill, PrimarySkill);
    }

    function setPrimarySkill(primarySkill:PrimarySkill, value:Int, abs:Int) {
        if ((primarySkill:Int) < PrimarySkill.EXPERIENCE) {
            var skill = bonusSystemNode.getBonusLocalFirst(BonusSelector.getTypeSelector(BonusType.PRIMARY_SKILL)
            .and(BonusSelector.getSubTypeSelector(primarySkill))
            .and(BonusSelector.getSourceSelector(BonusSource.HERO_BASE_SKILL)));
//            assert(skill);

            if (abs > 0) {
                skill.val = value;
            } else {
                skill.val += value;
            }
            BonusSystemNode.treeHasChanged();
        } else if(primarySkill == PrimarySkill.EXPERIENCE) {
            if (abs > 0) {
                exp = value;
            } else {
                exp += value;
            }
        }
    }

    function getLevelUpProposedSecondarySkills():Array<SecondarySkill> {
        var obligatorySkills:Array<SecondarySkill> = []; //hero is offered magic school or wisdom if possible
        if (skillsInfo.wisdomCounter == 0) {
            if (GObjectInstance.cb.isAllowed(2, SecondarySkill.WISDOM) && getSecSkillLevel(SecondarySkill.WISDOM) > 0)
                obligatorySkills.push(SecondarySkill.WISDOM);
        }
        if (skillsInfo.magicSchoolCounter == 0) {
            var ss = [SecondarySkill.FIRE_MAGIC, SecondarySkill.AIR_MAGIC, SecondarySkill.WATER_MAGIC, SecondarySkill.EARTH_MAGIC];

            Utils.shuffleArray(ss);

            for (skill in ss) {
                if (GObjectInstance.cb.isAllowed(2, skill) && getSecSkillLevel(skill) > 0) {//only schools hero doesn't know yet
                    obligatorySkills.push(skill);
                    break; //only one
                }
            }
        }

        var skills:Array<SecondarySkill> = [];
        //picking sec. skills for choice
        var basicAndAdv:Array<SecondarySkill> = [];
        var expert:Array<SecondarySkill> = [];
        var none:Array<SecondarySkill> = [];
        for(i in 0...VLC.instance.skillh.size()) {
            if (GObjectInstance.cb.isAllowed(2, i)) {
                if (none.indexOf(i) == -1) none.push((i:SecondarySkill));
            }
        }

        for (elem in secSkills) {
            if (elem.level < SecSkillLevel.EXPERT) {
                if (basicAndAdv.indexOf(elem.skill) == -1) basicAndAdv.push(elem.skill);
            } else {
                if (expert.indexOf(elem.skill) == -1) expert.push(elem.skill);
            }
            none.remove(elem.skill);
        }
        for (s in obligatorySkills) { //don't duplicate them
            none.remove(s);
            basicAndAdv.remove(s);
            expert.remove(s);
        }

        //first offered skill:
        // 1) give obligatory skill
        // 2) give any other new skill
        // 3) upgrade existing
        if (canLearnSkill() && obligatorySkills.length > 0) {
            skills.push(obligatorySkills[0]);
        } else if(none.length > 0 && canLearnSkill()) { //hero have free skill slot
            skills.push(type.heroClass.chooseSecSkill(none)); //new skill
            none.remove(skills[skills.length - 1]);
        } else if(basicAndAdv.length > 0) {
            skills.push(type.heroClass.chooseSecSkill(basicAndAdv)); //upgrade existing
            basicAndAdv.remove(skills[skills.length - 1]);
        }

        //second offered skill:
        //1) upgrade existing
        //2) give obligatory skill
        //3) give any other new skill
        if (basicAndAdv.length > 0) {
            var s:SecondarySkill = type.heroClass.chooseSecSkill(basicAndAdv);//upgrade existing
            skills.push(s);
            basicAndAdv.remove(s);
        } else if (canLearnSkill() && obligatorySkills.length > 1) {
            skills.push(obligatorySkills[1]);
        } else if(none.length > 0 && canLearnSkill()) {
            skills.push(type.heroClass.chooseSecSkill(none)); //give new skill
            none.remove(skills[skills.length - 1]);
        }

        if (skills.length == 2) // Fix for #1868 to avoid changing logic (possibly causing bugs in process)
            Utils.swap(skills, 0, 1);
        return skills;
    }

    function getSecSkillLevel(skill:SecondarySkill) {
        for (elem in secSkills) {
            if (elem.skill == skill) {
                return elem.level;
            }
        }
        return 0;
    }

    function canLearnSkill() {
        return secSkills.length < GameConstants.SKILL_PER_HERO;
    }

    function nextSecondarySkill():Null<SecondarySkill> {
        //assert(gainsLevel());

        var chosenSecondarySkill:Null<SecondarySkill> = null;
        var proposedSecondarySkills = getLevelUpProposedSecondarySkills();
        if (proposedSecondarySkills.length > 0) {
            var learnedSecondarySkills:Array<SecondarySkill> = [];
            for (secondarySkill in proposedSecondarySkills) {
                if (getSecSkillLevel(secondarySkill) > 0) {
                    learnedSecondarySkills.push(secondarySkill);
                }
            }

            if(learnedSecondarySkills.length == 0) {
                // there are only new skills to learn, so choose anyone of them
                chosenSecondarySkill = proposedSecondarySkills[Std.random(proposedSecondarySkills.length)];
            } else {
                // preferably upgrade a already learned secondary skill
                chosenSecondarySkill = proposedSecondarySkills[Std.random(learnedSecondarySkills.length)];
            }
        }
        return chosenSecondarySkill;
    }

    public function setSecSkillLevel(which:SecondarySkill, val:Int, abs:Bool):Void {
        if(getSecSkillLevel(which) == 0) {
            secSkills.push({skill:which, level: val});
            updateSkillBonus(which, val);
        } else {
            for (elem in secSkills) {
                if(elem.skill == which) {
                    if (abs)
                        elem.level = val;
                    else
                        elem.level += val;

                    if (elem.level > 3) //workaround to avoid crashes when same sec skill is given more than once
                    {
                        trace('Skill $which increased over limit! Decreasing to Expert.');
                        elem.level = 3;
                    }
                    updateSkillBonus(which, elem.level); //when we know final value
                }
            }
        }
    }

    function updateSkillBonus(which:SecondarySkill, val:Int) {
        bonusSystemNode.removeBonuses(BonusSelector.getSourceAndIdSelector(BonusSource.SECONDARY_SKILL, which));
        var skillBonus = VLC.instance.skillh.getAt(which).at(val).effects;
        for (b in skillBonus)
            bonusSystemNode.addNewBonus(b);
    }

    function levelUp(skills:Array<SecondarySkill>) {
        ++level;

        //deterministic secondary skills
        skillsInfo.magicSchoolCounter = (skillsInfo.magicSchoolCounter + 1) % maxlevelsToMagicSchool();
        skillsInfo.wisdomCounter = (skillsInfo.wisdomCounter + 1) % maxlevelsToWisdom();
        if (skills.indexOf(SecondarySkill.WISDOM) > -1) {
            skillsInfo.resetWisdomCounter();
        }

        var spellSchools = [SecondarySkill.FIRE_MAGIC, SecondarySkill.AIR_MAGIC, SecondarySkill.WATER_MAGIC, SecondarySkill.EARTH_MAGIC];
        for (skill in spellSchools) {
            if (skills.indexOf(skill) > -1) {
                skillsInfo.resetMagicSchoolCounter();
                break;
            }
        }

        //update specialty and other bonuses that scale with level
        BonusSystemNode.treeHasChanged();
    }

    function maxlevelsToMagicSchool() {
        return type.heroClass.isMagicHero() ? 3 : 4;
    }

    function maxlevelsToWisdom() {
        return type.heroClass.isMagicHero() ? 3 : 6;
    }

    public function getTotalStrength() {
        var ret = getFightingStrength() * _creatureSet.getArmyStrength();
        return Std.int(ret);
    }

    public function addSpellToSpellbook(spell:SpellId) {
        spells.push(spell);
    }

    public function removeSpellToSpellbook(spell:SpellId) {
        spells.remove(spell);
    }
}
