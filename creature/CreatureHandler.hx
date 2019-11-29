package lib.creature;

import haxe.Json;
import Reflect;
import lib.mod.VLC;
import data.H3mConfigData;
import lib.herobonus.Bonus;
import lib.herobonus.BonusList;
import constants.CreatureType;
import lib.mod.IHandlerBase;

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

    public function new() {
    }

    public function loadObject(scope:String, name:String, data:Dynamic, index:UInt = 0) {
        
    }

    public function loadLegacyData(dataSize:Int):Array<Dynamic> {
        var h3Data:Array<Dynamic> = [];
        creatures = [];
        var parser:Array<Array<Dynamic>> = Json.parse(H3mConfigData.data.get("DATA/CRTRAITS.TXT"));

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
        var parser:Array<Array<Dynamic>> = Json.parse(H3mConfigData.data.get("DATA/CRANIM.TXT"));

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
}
