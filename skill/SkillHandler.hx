package lib.skill;

import constants.SecondarySkill;
import utils.JsonUtils;
import constants.GameConstants;
import data.H3mConfigData;
import haxe.Json;
import lib.mod.HandlerBase;

using Reflect;

class SkillHandler extends HandlerBase<SecondarySkill, Skill> {
    public function new() {
        super();
    }

    override public function loadFromJson(json:Dynamic, identifier:String, index:Int):Skill {
        var skill = new Skill((index:SecondarySkill), identifier);

        skill.name = json.field("name");
        var gainChanceObj:Dynamic = json.field("gainChance");
        if (gainChanceObj != null) {
            if (Std.is(gainChanceObj, Int)) {
                skill.gainChance[0] = json.field("gainChance");
                skill.gainChance[1] = json.field("gainChance");
            } else {
                skill.gainChance[0] = json.field("gainChance").field("might");
                skill.gainChance[1] = json.field("gainChance").field("magic");
            }
        }
        for(level in 1...StringConstants.SECONDARY_SKILLS_LEVELS.length) {
            var levelName:String = StringConstants.SECONDARY_SKILLS_LEVELS[level]; // basic, advanced, expert
            var levelNode:Dynamic = json.field(levelName);
            // parse bonus effects
            var effectsObj:Dynamic = levelNode.field("effects");
            for(bonusName in effectsObj.fields()) {
                var bonus = JsonUtils.parseBonus(effectsObj.field(bonusName));
                skill.addNewBonus(bonus, level);
            }
            var skillAtLevel:LevelInfo = skill.getLevelInfoFor(level);
            skillAtLevel.description = levelNode.field("description");
            skillAtLevel.iconSmall = levelNode.field("images").field("small");
            skillAtLevel.iconMedium = levelNode.field("images").field("medium");
            skillAtLevel.iconLarge = levelNode.field("images").field("large");
        }
        trace('loaded secondary skill $identifier(${skill.id})');

        return skill;
    }

    override public function loadLegacyData(dataSize:Int):Array<Dynamic> {
        var parser:Array<Dynamic> = Json.parse(H3mConfigData.data.get("DATA/SSTRAITS.TXT"));

        var skillNames:Array<String> = [];
        var skillInfoTexts:Array<Array<String>> = [];
        for (lineObj in parser) {
            var pos = 0;
            skillNames.push(parser[pos++]);
            var skillInfoText:Array<String> = [];
            for (i in 0...3) {
                skillInfoText.push(parser[pos++]);
            }
            skillInfoTexts.push(skillInfoText);
        }

//        trace(skillNames.length == GameConstants.SKILL_QUANTITY);

        var legacyData:Array<Dynamic> = [];
        for (id in 0...GameConstants.SKILL_QUANTITY) {
            var skillNode = {name: skillNames[id]};
            for (level in 1...StringConstants.SECONDARY_SKILLS_LEVELS.length) {
                var desc:String = skillInfoTexts[id][level - 1];
                var levelNode = {description: desc, effects: {}}; // create empty effects objects
                Reflect.setField(skillNode, StringConstants.SECONDARY_SKILLS_LEVELS[level], levelNode);
            }
        }

        return legacyData;
    }

    override public function getTypeNames():Array<String>{
        return ["skill", "secondarySkill"];
    }
}
