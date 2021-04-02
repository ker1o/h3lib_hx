package spells;

import filesystem.FileCache;
import Array;
import constants.GameConstants;
import constants.SpellId;
import herobonus.BonusSource;
import herobonus.BonusType;
import mod.HandlerBase;
import mod.VLC;
import spells.Spell.ProjectileInfo;
import Reflect;
import utils.JsonUtils;

using Reflect;

class SpellHandler extends HandlerBase<SpellId, Spell> {

    private static var LEVEL_NAMES = ["none", "basic", "advanced", "expert"];

    public function new() {
        super();
    }

    override public function getTypeNames():Array<String> {
        return ["spell"];
    }

    override public function loadLegacyData(dataSize:Int):Array<Dynamic> {
        function read(combat:Bool, ability:Bool, legacyData:Array<Dynamic>, groupParseObject:Array<Dynamic>) {
            var readSchool = function(data:Dynamic, schoolName:String, value:Bool) {
                if (value) {
                    Reflect.setField(data, schoolName, value);
                }
            }

            for (parseObject in groupParseObject) {
                var lineNode = {};
                var id = legacyData.length;
                var pos:Int = 0;

                Reflect.setField(lineNode, "index", id);
                Reflect.setField(lineNode, "type", ability ? "ability" : (combat ? "combat" : "adventure"));

                Reflect.setField(lineNode, "name", parseObject[pos++]);
                pos++;

                Reflect.setField(lineNode, "level", parseObject[pos++]);

                var schools = {};
                readSchool(schools, "earth", parseObject[pos++]);
                readSchool(schools, "water", parseObject[pos++]);
                readSchool(schools, "fire", parseObject[pos++]);
                readSchool(schools, "air", parseObject[pos++]);

                var levelsObj = {};
                var costs = [for (i in 0...GameConstants.SPELL_SCHOOL_LEVELS) parseObject[pos++]];
                Reflect.setField(lineNode, "power", parseObject[pos++]);
                var powers = [for (i in 0...GameConstants.SPELL_SCHOOL_LEVELS) parseObject[pos++]];

                var chancesObj = {};
                for (i in 0...GameConstants.F_NUMBER) {
                    Reflect.setField(chancesObj, StringConstants.TOWN_TYPE[i], parseObject[pos++]);
                }
                Reflect.setField(lineNode, "gainChance", chancesObj);

                var aiVals = [for (i in 0...GameConstants.SPELL_SCHOOL_LEVELS) parseObject[pos++]];

                var descriptions = [for (i in 0...GameConstants.SPELL_SCHOOL_LEVELS) parseObject[pos++]];

                pos++; //ignore attributes. All data present in JSON

                for (i in 0...GameConstants.SPELL_SCHOOL_LEVELS) {
                    var level = {description: descriptions[i], cost: costs[i], power: powers[i], aiValue: aiVals[i]};
                    Reflect.setField(levelsObj, LEVEL_NAMES[i], level);
                }

                legacyData.push(lineNode);
            }
        }


        var legacyData:Array<Dynamic> = [];

        var parser = FileCache.instance.getConfig("DATA/SPTRAITS.TXT");

        read(false, false, legacyData, parser[0]); //read adventure map spells
        read(true, false, legacyData, parser[1]); //read battle spells
        read(true, true, legacyData, parser[2]);//read creature abilities

        //TODO: maybe move to config
        //clone Acid Breath attributes for Acid Breath damage effect
        var temp = Reflect.copy(legacyData[SpellId.ACID_BREATH_DEFENSE]);
        Reflect.setField(temp, "index", SpellId.ACID_BREATH_DAMAGE);
        legacyData.push(temp);

        return legacyData;
    }

    override public function loadFromJson(json:Dynamic, identifier:String, index:Int):Spell {
        var id:SpellId = (index:SpellId);

        var spell = new Spell();
        spell.id = id;
        spell.identifier = identifier;

        var type:Dynamic = json.field("type");

        if(type == "ability") {
            spell.creatureAbility = true;
            spell.combatSpell = true;
        } else {
            spell.creatureAbility = false;
            spell.combatSpell = type == "combat";
        }


        spell.name = json.field("name");

//        logMod.trace("%s: loading spell %s", __FUNCTION__, spell.name);

        var schoolNames:Dynamic = json.field("school");

        for(info in SpellConfig.SCHOOL) {
            spell.school.set(info.id, schoolNames.field(info.jsonName));
        }

        spell.level = json.field("level");
        spell.power = json.field("power");

        spell.defaultProbability = json.field("defaultGainChance");

        var gainChance:Dynamic = json.field("gainChance");
        for(nodeField in gainChance.fields()) {
            var chance:Int = gainChance.field(nodeField);

            VLC.instance.modh.identifiers.requestIdentifier(/*node.second.meta*/"core", "faction", nodeField, function(factionId:Int) {
                spell.probabilities.set(factionId, chance);
            });
        }

        var targetType:String = json.field("targetType");

        if(targetType == "NO_TARGET") {
            spell.targetType = AimType.NO_TARGET;
        } else if(targetType == "CREATURE") {
            spell.targetType = AimType.CREATURE;
        } else if(targetType == "OBSTACLE") {
            spell.targetType = AimType.OBSTACLE;
        } else if(targetType == "LOCATION") {
            spell.targetType = AimType.LOCATION;
        } else {
            trace('Spell ${spell.name}: target type ${targetType == "" ? "empty" : "unknown ("+targetType+")"} - assumed NO_TARGET.');
        }

        var counters:Dynamic = json.field("counters");
        for(counteredSpellField in counters.fields()) {
            if(counters.field(counteredSpellField)) {
                VLC.instance.modh.identifiers.requestIdentifierByFullName(/*json.meta*/"core", counteredSpellField, function(id:Int) {
                    spell.counteredSpells.push((id:SpellId));
                });
            }
        }

        //TODO: more error checking - f.e. conflicting flags
        var flags:Dynamic = json.field("flags");

        //by default all flags are set to false in constructor

        spell.isDamage = flags.field("damage"); //do this before "offensive"

        if(flags.field("offensive")) {
            spell.setIsOffensive(true);
        }

        if(flags.field("rising")) {
            spell.setIsRising(true);
        }

        var implicitPositiveness:Bool = spell.isOffensive || spell.isRising; //(!) "damage" does not mean NEGATIVE  --AVS

        if(flags.field("indifferent")) {
            spell.positiveness = SpellPositiveness.NEUTRAL;
        } else if(flags.field("negative")) {
            spell.positiveness = SpellPositiveness.NEGATIVE;
        } else if(flags.field("positive")) {
            spell.positiveness = SpellPositiveness.POSITIVE;
        } else if(!implicitPositiveness) {
            spell.positiveness = SpellPositiveness.NEUTRAL; //duplicates constructor but, just in case
            // logMod.error("Spell %s: no positiveness specified, assumed NEUTRAL.", spell.name);
        }

        spell.isSpecial = flags.field("special");

        var findBonus = function(name:String, vec:Array<BonusType>) {
            var bonusType = BonusType.parse(name);
            if(bonusType == BonusType.UNDEFINED) {
                trace('Spell ${spell.name}: invalid bonus name {name}');
            } else {
                vec.push(bonusType);
            }
        };

        var readBonusStruct = function (name:String, vec:Array<BonusType>) {
            var jsonData:Dynamic = json.field(name);
            for(bonusDataField in jsonData.fields()) {
                var flag:Bool = jsonData.field(bonusDataField);
                if(flag) {
                    findBonus(bonusDataField, vec);
                }
            }
        };

        if(json.field("targetCondition") == null) {
            var immunities = new Array<BonusType>();
            var absoluteImmunities = new Array<BonusType>();
            var limiters = new Array<BonusType>();
            var absoluteLimiters = new Array<BonusType>();

            readBonusStruct("immunity", immunities);
            readBonusStruct("absoluteImmunity", absoluteImmunities);
            readBonusStruct("limit", limiters);
            readBonusStruct("absoluteLimit", absoluteLimiters);

            if(!(immunities.length == 0 && absoluteImmunities.length == 0 && limiters.length == 0 && absoluteLimiters.length == 0)) {
//                logMod.warn("Spell %s has old target condition format. Expected configuration: ", spell.name);
                spell.targetCondition = spell.convertTargetCondition(immunities, absoluteImmunities, limiters, absoluteLimiters);
//                logMod.warn("\n\"targetCondition\" : %s", spell.targetCondition.toJson());
            }
        } else {
            spell.targetCondition = json.field("targetCondition");

            //TODO: could this be safely merged instead of discarding?
            if(json.field("immunity") != null) {
                trace('Spell ${spell.name} \'immunity\' field mixed with \'targetCondition\' discarded');
            }
            if(json.field("absoluteImmunity") != null) {
                trace('Spell ${spell.name} \'absoluteImmunity\' field mixed with \'targetCondition\' discarded');
            }
            if(json.field("limit") != null) {
                trace('Spell ${spell.name} \'limit\' field mixed with \'targetCondition\' discarded');
            }
            if(json.field("absoluteLimit") != null) {
                trace('Spell ${spell.name} \'absoluteLimit\' field mixed with \'targetCondition\' discarded');
            }
        }

        var graphicsNode:Dynamic = json.field("graphics");

        spell.iconImmune = graphicsNode.field("iconImmune");
        spell.iconBook = graphicsNode.field("iconBook");
        spell.iconEffect = graphicsNode.field("iconEffect");
        spell.iconScenarioBonus = graphicsNode.field("iconScenarioBonus");
        spell.iconScroll = graphicsNode.field("iconScroll");

        var animationNode:Dynamic = json.field("animation");

        var loadAnimationQueue = function(jsonName:String, q:Array<AnimationItem>) {
            if (animationNode != null && animationNode.hasField(jsonName)) {
                var queueNode = (animationNode.field(jsonName):Array<Dynamic>);
                for(item in queueNode) {
                    var newItem = new AnimationItem();

                    if(Std.isOfType(item, String)) {
                        newItem.resourceName = item;
                    } else if(Std.isOfType(item, Float)) {
                        newItem.pause = item;
                    } else if(Std.isOfType(item, Dynamic)) {
                        newItem.resourceName = item.field("defName");

                        var vPosStr:String = item.field("verticalPosition");
                        if("bottom" == vPosStr) newItem.verticalPosition = VerticalPosition.BOTTOM;
                    }

                    q.push(newItem);
                }
            }
        };

        loadAnimationQueue("affect", spell.animationInfo.affect);
        loadAnimationQueue("cast", spell.animationInfo.casting);
        loadAnimationQueue("hit", spell.animationInfo.hit);

        if (animationNode != null && animationNode.hasField("projectile")) {
            var projectile:Array<Dynamic> = animationNode.field("projectile");
            for(item in projectile) {
                var info = new ProjectileInfo();
                info.resourceName = item.field("defName");
                info.minimumAngle = item.field("minimumAngle");

                spell.animationInfo.projectile.push(info);
            }
        }

        var soundsNode:Dynamic = json.field("sounds");
        spell.castSound = soundsNode.field("cast");

        //load level attributes
        var levelsCount:Int = GameConstants.SPELL_SCHOOL_LEVELS;

        for(levelIndex in 0...levelsCount) {
            var levelNode:Dynamic = json.field("levels").field(LEVEL_NAMES[levelIndex]);

            var levelObject:LevelInfo = new LevelInfo();
            spell.levels[levelIndex] = levelObject;

            var levelPower:Int = levelObject.power = levelNode.field("power");

            levelObject.description   = levelNode.field("description");
            levelObject.cost          = levelNode.field("cost");
            levelObject.AIValue       = levelNode.field("aiValue");
            levelObject.smartTarget   = levelNode.field("targetModifier").field("smart");
            levelObject.clearTarget   = levelNode.field("targetModifier").field("clearTarget");
            levelObject.clearAffected = levelNode.field("targetModifier").field("clearAffected");
            levelObject.range         = levelNode.field("range");

            var effects:Dynamic = levelNode.field("effects");
            for(elemField in effects.fields()) {
                var bonusNode:Dynamic = effects.field(elemField);
                var b = JsonUtils.parseBonus(bonusNode);
                var usePowerAsValue:Bool = bonusNode.field("val") == null;

                b.sid = spell.id; //for all
                b.source = BonusSource.SPELL_EFFECT;//for all

                if (usePowerAsValue) b.val = levelPower;

                levelObject.effects.push(b);
            }

            var cumulativeEffects:Dynamic = levelNode.field("cumulativeEffects");
            for(elemField in cumulativeEffects.fields()) {
                var bonusNode:Dynamic = cumulativeEffects.field(elemField);
                var b = JsonUtils.parseBonus(bonusNode);
                var usePowerAsValue = bonusNode.field("val") == null;

                b.sid = spell.id; //for all
                b.source = BonusSource.SPELL_EFFECT;//for all

                if(usePowerAsValue) b.val = levelPower;

                levelObject.cumulativeEffects.push(b);
            }

            if(levelNode.field("battleEffects") != null && levelNode.field("battleEffects").fields().length > 0) {
                levelObject.battleEffects = levelNode.field("battleEffects");

                if(levelObject.cumulativeEffects.length > 0 || levelObject.effects.length > 0 || spell.isOffensiveSpell()) {
                    trace('Mixing %s special effects with old format effects gives unpredictable result');
                }
            }
        }
        return spell;
    }
}
