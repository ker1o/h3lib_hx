package lib.spells;

import Array;
import constants.GameConstants;
import constants.SpellId;
import data.H3mConfigData;
import haxe.Json;
import lib.mod.HandlerBase;
import lib.mod.IHandlerBase;
import Reflect;

class SpellHandler extends HandlerBase<SpellId, Spell> implements IHandlerBase {

    private static var LEVEL_NAMES = ["none", "basic", "advanced", "expert"];

    public function new() {
        super();
    }

    override public function loadLegacyData(dataSize:Int):Array<Dynamic> {
        function read(combat:Bool, ability:Bool, legacyData:Array<Dynamic>, parseObject:Array<Dynamic>) {
            var readSchool = function(data:Dynamic, schoolName:String, value:Bool) {
                if (value) {
                    Reflect.setField(data, schoolName, value);
                }
            }

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

            var descriptions:Array<String> = [for (i in 0...GameConstants.SPELL_SCHOOL_LEVELS) parseObject[pos++]];

            pos++; //ignore attributes. All data present in JSON

            for (i in 0...GameConstants.SPELL_SCHOOL_LEVELS) {
                var level = {description: descriptions[i], cost: costs[i], power: powers[i], aiValue: aiVals[i]};
                Reflect.setField(levelsObj, LEVEL_NAMES[i], level);
            }

            legacyData.push(lineNode);
        }


        var legacyData:Array<Dynamic> = [];

        var parser = Json.parse(H3mConfigData.data.get("DATA/SPTRAITS.TXT"));

        read(false, false, legacyData, parser); //read adventure map spells
        read(true, false, legacyData, parser); //read battle spells
        read(true, true, legacyData, parser);//read creature abilities

        //TODO: maybe move to config
        //clone Acid Breath attributes for Acid Breath damage effect
        var temp = Reflect.copy(legacyData[SpellId.ACID_BREATH_DEFENSE]);
        Reflect.setField(temp, "index", SpellId.ACID_BREATH_DAMAGE);
        legacyData.push(temp);

        return legacyData;
    }

}
