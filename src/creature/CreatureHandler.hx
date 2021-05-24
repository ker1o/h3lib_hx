package creature;

import filesystem.FileCache;
import constants.CreatureType;
import constants.GameConstants;
import constants.id.CreatureId;
import constants.Obj;
import constants.PrimarySkill;
import herobonus.Bonus;
import herobonus.BonusDuration;
import herobonus.BonusList;
import herobonus.BonusSource;
import herobonus.BonusSystemNode;
import herobonus.BonusType;
import herobonus.LimitEffect;
import herobonus.RankRangeLimiter;
import mod.IHandlerBase;
import mod.ModHandler;
import mod.VLC;
import res.ResourceSet;
import Reflect;
import utils.JsonUtils;

using Reflect;

typedef SkillsTuple = {skill1:Int, skill2:Int};

class CreatureHandler implements IHandlerBase {
    public var doubledCreatures:Array<CreatureType>; //they get double week
    public var creatures:Array<Creature>; //creature ID -> creature info.

    //stack exp
    public var expRanks:Array<Array<Int>>; // stack experience needed for certain rank, index 0 for other tiers (?)
    public var maxExpPerBattle:Array<Int>; //%, tiers same as above
    public var expAfterUpgrade:Int;//multiplier in %

    //Commanders
    public var commanderLevelPremy:BonusList; //bonus values added with each level-up
    public var skillLevels:Array<Array<Int>>; //how much of a bonus will be given to commander with every level. SPELL_POWER also gives CASTS and RESISTANCE
    public var skillRequirements:Array<{bonus:Bonus, skills:SkillsTuple}>; // first - Bonus, second - which two skills are needed to use it

    public var ABILITIES_MAP:Map<String, Dynamic> = [
        "FLYING_ARMY" => {type: "FLYING_ARMY"},
        "SHOOTING_ARMY" => {type: "SHOOTING_ARMY"},
        "SIEGE_WEAPON" => {type: "SIEGE_WEAPON"},
        "const_free_attack" => {type: "const_free_attack"},
        "IS_UNDEAD" => {type: "IS_UNDEAD"},
        "const_no_melee_penalty" => {type: "const_no_melee_penalty"},
        "const_jousting" => {type: "const_jousting"},
        "KING_1" => {type: "KING_1"},
        "KING_2" => {type: "KING_2"},
        "KING_3" => {type: "KING_3"},
        "const_no_wall_penalty" => {type: "const_no_wall_penalty"},
        "CATAPULT" => {type: "CATAPULT"},
        "MULTI_HEADED" => {type: "MULTI_HEADED"},
        "IMMUNE_TO_MIND_SPELLS" => {type: "IMMUNE_TO_MIND_SPELLS"},
        "HAS_EXTENDED_ATTACK" => {type: "HAS_EXTENDED_ATTACK"}
    ];

    private var allCreatures:BonusSystemNode;
    private var creaturesOfLevel:Array<BonusSystemNode>;

    public static function addAbility(cre:Creature, abilityArr:Array<Dynamic>) {
        var bonus = new Bonus();
        var type:String = abilityArr[0];

        var it:BonusType = BonusType.parse(type);

        if (it == BonusType.UNDEFINED) {
            if (type == "DOUBLE_WIDE") {
                cre.doubleWide = true;
            } else if (type == "ENEMY_MORALE_DECREASING") {
                cre.addBonus(-1, BonusType.MORALE);
                cre.getBonusList().back().effectRange = LimitEffect.ONLY_ENEMY_ARMY;
            } else if (type == "ENEMY_LUCK_DECREASING") {
                cre.addBonus(-1, BonusType.LUCK);
                cre.getBonusList().back().effectRange = LimitEffect.ONLY_ENEMY_ARMY;
            } else {
                //logGlobal.error("Error: invalid ability type %s in creatures config", type);
            }
            return;
        }

        bonus.type = it;

        JsonUtils.parseTypedBonusShort(abilityArr, bonus);

        bonus.source = BonusSource.CREATURE_ABILITY;
        bonus.sid = cre.idNumber;

        cre.addNewBonus(bonus);
    }

    public function new() {
        doubledCreatures = [];
        expRanks = [];
        maxExpPerBattle = [];

        creatures = [];
        expAfterUpgrade = 0;
        allCreatures = new BonusSystemNode();
        allCreatures.setDescription("All creatures");
        creaturesOfLevel = [for(i in 0...(GameConstants.CREATURES_PER_TOWN + 1)) new BonusSystemNode()];
        creaturesOfLevel[0].setDescription("Creatures of unnormalized tier");
        for(i in 1...creaturesOfLevel.length) {
            creaturesOfLevel[i].setDescription("Creatures of tier " + i);
        }

        loadCommanders();
    }

    private function loadCommanders() {
        var data:Dynamic = FileCache.instance.getConfig("config/commanders.json");
        data.setField("meta", "core"); // assume that commanders are in core mod (for proper bonuses resolution)

        var config:Dynamic = data; // switch to const data accessors

        commanderLevelPremy = [];
        var bonusPerLevelArr:Array<Array<Dynamic>> = config.field("bonusPerLevel");
        for (bonus in bonusPerLevelArr) {
            commanderLevelPremy.push(JsonUtils.parseBonus(bonus));
        }

        skillLevels = [];
        var i:Int = 0;
        var skillLevelsArr:Array<Dynamic> = config.field("skillLevels");
        for (skill in skillLevelsArr) {
            skillLevels.push([]);
            var skillLevelArr:Array<Dynamic> = skill.field("levels");
            for (skillLevel in skillLevelArr) {
                skillLevels[i].push(skillLevel);
            }
            ++i;
        }

        skillRequirements = [];
        var abilityRequirements:Array<Dynamic> = config.field("abilityRequirements");
        for (ability in abilityRequirements) {
            var a = {
                bonus: JsonUtils.parseBonusVector((ability.field("ability"):Array<Dynamic>)),
                skills: {
                    skill1: ability.field("skills")[0],
                    skill2: ability.field("skills")[1]
                }
            };
            skillRequirements.push(a);
        }

    }

    public function loadObject(scope:String, name:String, data:Dynamic, index:UInt = 0) {
        var object:Creature = loadFromJson(data, ModHandler.normalizeIdentifier(scope, "core", name));
        if (index == 0) {
            index = creatures.length;
        }
        object.setId(new CreatureId(cast(index, CreatureType)));
        object.iconIndex = object.idNumber + 2;

        if (data.field("hasDoubleWeek")) {
            if (doubledCreatures.indexOf(object.idNumber) == -1) {
                doubledCreatures.push(object.idNumber);
            }
        }
        creatures[index] = object;

        VLC.instance.modh.identifiers.requestIdentifier(scope, "object", "monster", function(index:Int) {
            var conf:Dynamic = {meta: scope};
            //conf.setMeta(scope);

            VLC.instance.objtypeh.loadSubObject(object.identifier, conf, Obj.MONSTER, object.idNumber);
            if (object.advMapDef != "") {
                var templ:Dynamic = {animation: object.advMapDef};
                VLC.instance.objtypeh.getHandlerFor(Obj.MONSTER, object.idNumber).addTemplate(templ);
            }

            // object does not have any templates - this is not usable object (e.g. pseudo-creature like Arrow Tower)
            if (VLC.instance.objtypeh.getHandlerFor(Obj.MONSTER, object.idNumber).getTemplates().length == 0) {
                VLC.instance.objtypeh.removeSubObject(Obj.MONSTER, object.idNumber);
            }
        });

        VLC.instance.modh.identifiers.registerObject(scope, "creature", name, object.idNumber);
        var extraNames:Array<Dynamic> = data.field("extraNames");
        if (extraNames != null) {
            for(node in extraNames) {
                VLC.instance.modh.identifiers.registerObject(scope, "creature", node, object.idNumber);
            }
        }
    }

    public function loadLegacyData(dataSize:Int):Array<Dynamic> {
        var h3Data:Array<Dynamic> = [];
        var parser:Array<Array<Dynamic>> = FileCache.instance.getConfig("DATA/CRTRAITS.TXT");

        for(i in 0...dataSize) {
            var parserData = parser[i];
            var pos = 0;
            var data = {};
            var nameData = {singular: parserData[pos++], plural: parserData[pos++]};
            Reflect.setField(data, "name", nameData);

            var costData = {};
            for(v in 0...7) {
                Reflect.setField(costData, StringConstants.RESOURCE_NAMES[v], parserData[pos++]);
            }
            Reflect.setField(data, "cost", costData);

            Reflect.setField(data, "fightValue", parserData[pos++]);
            Reflect.setField(data, "aiValue", parserData[pos++]);
            Reflect.setField(data, "growth", parserData[pos++]);
            Reflect.setField(data, "horde", parserData[pos++]);

            Reflect.setField(data, "hitPoints", parserData[pos++]);
            Reflect.setField(data, "speed", parserData[pos++]);
            Reflect.setField(data, "attack", parserData[pos++]);
            Reflect.setField(data, "defense", parserData[pos++]);

            var damageData = {min: parserData[pos++], max: parserData[pos++]};
            Reflect.setField(data, "damage", damageData);

            var shots:Float = parserData[pos++];
            if(shots > 0) {
                Reflect.setField(data, "shots", shots);
            }

            var spells:Float = parserData[pos++];
            if(spells > 0) {
                Reflect.setField(data, "spellPoints", shots);
            }

            var advMapAmountData = {min: parserData[pos++], max: parserData[pos++]};
            Reflect.setField(data, "advMapAmount", advMapAmountData);
            Reflect.setField(data, "abilityText", parserData[pos++]);
            loadBonuses(data, parserData[pos++]); //Attributes

            h3Data.push(data);
        }

        loadAnimationInfo(h3Data, dataSize);

        return h3Data;
    }


    private function loadFromJson(node:Dynamic, identifier:String):Creature {
        var cre = new Creature();

        var name:Dynamic = node.field("name");
        cre.identifier = identifier;
        cre.nameSing = name.field("singular");
        cre.namePl = name.field("plural");

        cre.cost = (node.field("cost"):ResourceSet);

        cre.fightValue = node.field("fightValue");
        cre.AIValue = node.field("aiValue");
        cre.growth = node.field("growth");
        cre.hordeGrowth = node.field("horde"); // Needed at least until configurable buildings

        cre.addBonus(node.field("hitPoints"), BonusType.STACK_HEALTH);
        cre.addBonus(node.field("speed"), BonusType.STACKS_SPEED);
        cre.addBonus(node.field("attack"), BonusType.PRIMARY_SKILL, PrimarySkill.ATTACK);
        cre.addBonus(node.field("defense"), BonusType.PRIMARY_SKILL, PrimarySkill.DEFENSE);

        cre.addBonus(node.field("damage").field("min"), BonusType.CREATURE_DAMAGE, 1);
        cre.addBonus(node.field("damage").field("max"), BonusType.CREATURE_DAMAGE, 2);

//        assert(node.field("damage").field("min") <= node.field("damage").field("max"));

        cre.ammMin = node.field("advMapAmount").field("min");
        cre.ammMax = node.field("advMapAmount").field("max");
        //assert(cre.ammMin <= cre.ammMax);

        if (node.field("shots") != null) {
            cre.addBonus(node.field("shots"), BonusType.SHOTS);
        }

        // ToDo: check it
        if (node.field("spellPoints") == null) {
            cre.addBonus(node.field("spellPoints"), BonusType.CASTS);
        }

        cre.doubleWide = node.field("doubleWide");

        loadStackExperience(cre, node.field("stackExperience"));
        loadJsonAnimation(cre, node.field("graphics"));
        loadCreatureJson(cre, node);
        return cre;
    }

    function loadStackExperience(creature:Creature, input:Array<Dynamic>) {
        if (input == null) return;

        for (exp in input) {
            var bonus = JsonUtils.parseBonus(exp.field("bonus"));
            bonus.source = BonusSource.STACK_EXPERIENCE;
            bonus.duration = BonusDuration.PERMANENT;
            var values:Array<Dynamic> = exp.field("values");
            var lowerLimit:Int = 1;//, upperLimit = 255;
            if (Std.is(values[0], Bool)) {
                for (val in values) {
                    if (val == true) {
                        bonus.limiter = new RankRangeLimiter(lowerLimit);
                        creature.addNewBonus(bonus); //bonuses must be unique objects
                        break; //TODO: allow bonuses to turn off?
                    }
                    ++lowerLimit;
                }
            } else {
                var lastVal:Int = 0;
                for (val in values) {
                    if (val != lastVal) {
                        bonus.val = (val:Int) - lastVal;
                        bonus.limiter = new RankRangeLimiter(lowerLimit);
                        creature.addNewBonus(bonus);
                    }
                    lastVal = val;
                    ++lowerLimit;
                }
            }
        }
    }

    private function loadJsonAnimation(cre:Creature, graphics:Dynamic) {
        if (graphics == null) return;

        cre.animation.timeBetweenFidgets = graphics.field("timeBetweenFidgets");
        cre.animation.troopCountLocationOffset = graphics.field("troopCountLocationOffset");

        var animationTime:Dynamic = graphics.field("animationTime");
        if (animationTime != null) {
            cre.animation.walkAnimationTime = animationTime.field("walk");
            cre.animation.idleAnimationTime = animationTime.field("idle");
            cre.animation.attackAnimationTime = animationTime.field("attack");
            cre.animation.flightAnimationDistance = animationTime.field("flight"); //?
        }

        var missile:Dynamic = graphics.field("missile");
        var offsets:Dynamic = missile.field("offset");
        if (offsets != null) {
            cre.animation.upperRightMissleOffsetX = offsets.field("upperX");
            cre.animation.upperRightMissleOffsetY = offsets.field("upperY");
            cre.animation.rightMissleOffsetX = offsets.field("middleX");
            cre.animation.rightMissleOffsetY = offsets.field("middleY");
            cre.animation.lowerRightMissleOffsetX = offsets.field("lowerX");
            cre.animation.lowerRightMissleOffsetY = offsets.field("lowerY");
        }

        if (missile != null) {
            cre.animation.attackClimaxFrame = missile.field("attackClimaxFrame");
            cre.animation.missleFrameAngles = missile.field("frameAngles");
        }

        cre.advMapDef = graphics.field("map");
        cre.smallIconName = graphics.field("iconSmall");
        cre.largeIconName = graphics.field("iconLarge");
    }

    private function loadCreatureJson(creature:Creature, config:Dynamic) {
        creature.level = config.field("level");
        creature.animDefName = config.field("graphics").field("animation");

        //FIXME: MOD COMPATIBILITY
        if (Std.is(config.field("abilities"), Array)) {
            var arr:Array<Dynamic> = config.field("abilities");
            for(ability in arr) {
                if (Std.is(ability, Array)) {
                    //assert(0); // should be unused now
                    addAbility(creature, ability); // used only for H3 creatures
                } else {
                    var b = JsonUtils.parseBonus(ability);
                    b.source = BonusSource.CREATURE_ABILITY;
                    b.duration = BonusDuration.PERMANENT;
                    creature.addNewBonus(b);
                }
            }
        } else {
            var struct:Dynamic = config.field("abilities");
            for(abilityKey in struct.fields()) {
                var ability = struct.field(abilityKey);
                if (ability != null) {
                    var b = JsonUtils.parseBonus(ability);
                    b.source = BonusSource.CREATURE_ABILITY;
                    b.duration = BonusDuration.PERMANENT;
                    creature.addNewBonus(b);
                }
            }
        }
    }

    private function loadBonuses(creature:Dynamic, bonuses:String) {
        var abilitiesData = {};
        var abilities = bonuses.split(" | ");
        for(ability in abilities) {
            Reflect.setField(abilitiesData, ability, ABILITIES_MAP.get(ability));
        }

        if(abilities.indexOf("DOUBLE_WIDE") > -1) {
            Reflect.setField(creature, "doubleWide", true);
        }

        if(abilities.indexOf("const_raises_morale") > -1) {
            var moraleNode = {type: "MORALE", val: 1, propagator: "HERO"};
            Reflect.setField(abilitiesData, "const_raises_morale", moraleNode);
        }

        if(abilities.indexOf("const_lowers_morale") > -1) {
            var moraleNode = {type: "MORALE", val: -1, effectRange: "ONLY_ENEMY_ARMY"};
            Reflect.setField(abilitiesData, "const_lowers_morale", moraleNode);
        }

        Reflect.setField(creature, "abilities", abilitiesData);
    }

    private function loadAnimationInfo(h3Data:Array<Dynamic>, dataSize:Int) {
        var parser:Array<Array<Dynamic>> = FileCache.instance.getConfig("DATA/CRANIM.TXT");

//        for(dd in 0...VLC.instance.modh.settings.data.get("textData")["creature"]) {
        for(creatureIndex in 0...dataSize) {
            var creatureObj = parser[creatureIndex];
            var unitAnimationInfo = loadUnitAnimInfo(creatureObj);
            Reflect.setField(h3Data[creatureIndex], "graphics", unitAnimationInfo);
        }
    }

    private function loadUnitAnimInfo(parser:Array<Dynamic>):Dynamic {
        var graphicsObj = {};
        var pos = 0;

        Reflect.setField(graphicsObj, "timeBetweenFidgets", parser[pos++]);

        var animationTimeObj = {walk: parser[pos++], attack: parser[pos++], flight: parser[pos++], idle: 10.0};
        Reflect.setField(graphicsObj, "animationTime", animationTimeObj);

        var offsetsObj = {upperX: parser[pos++], upperY: parser[pos++], middleX: parser[pos++], middleY: parser[pos++], lowerX: parser[pos++], lowerY: parser[pos++]};
        var missileObj = {offset: offsetsObj};

        var frameAngles:Array<Float> = [];
        for (i in 0...12) {
            frameAngles.push(parser[pos++]);
        }
        Reflect.setField(missileObj, "frameAngles", frameAngles);

        Reflect.setField(graphicsObj, "troopCountLocationOffset", parser[pos++]);
        Reflect.setField(missileObj, "attackClimaxFrame", parser[pos++]);

        // assume that creature is not a shooter and should not have whole missile field
        if(Reflect.field(missileObj, "frameAngles")[0] == 0 && Reflect.field(missileObj, "attackClimaxFrame") == 0) {
            Reflect.deleteField(graphicsObj, "missile");
        }

        return graphicsObj;
    }

    public function pickRandomMonster(tier:Int = 0):CreatureId {
        var r:Int = 0;
        if(tier == -1) {//pick any allowed creature
            do
            {
                r = creatures[Std.random(creatures.length - 1)].idNumber;
            } while (VLC.instance.creh.creatures[r] != null && VLC.instance.creh.creatures[r].special != null); // find first "not special" creature
        } else {
            var allowed:Array<CreatureId> = [];
            for (b in creaturesOfLevel[tier].getChildrenNodes()) {
                var crea:Creature = cast b;
                if(crea != null && !crea.special)
                    allowed.push(crea.idNumber);
            }

            if(allowed.length == 0)
            {
                trace("Cannot pick a random creature of tier %d!", tier);
                return (CreatureType.NONE:CreatureId);
            }

            return allowed[Std.random(allowed.length - 1)];
        }
        //assert (r >= 0); //should always be, but it crashed
        return (r:CreatureId);
    }

}
