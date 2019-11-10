package lib.hero;

import data.H3mConfigData;
import lib.mod.IHandlerBase;

class HeroClassHandler implements IHandlerBase {
    public var heroClasses:Array<HeroClass>;

    public function new() {
    }

    public function loadLegacyData(dataSize:Int):Array<Dynamic> {
        heroClasses = [];
        var h3Data:Array<Dynamic> = [];
        var parser = H3mConfigData.data.get("HCTRAITS.TXT");

        for(i in 0...dataSize) {
            var parserData = parser[i];
            var pos = 0;
            var entry = {};
            Reflect.setField(entry, "name", parserData[pos++]);

            var innerObj = {};
            for(skillName in StringConstants.PRIMARY_SKILLS) {
                Reflect.setField(innerObj, skillName, parserData[pos++]);
            }
            Reflect.setField(entry, "primarySkills", innerObj);

            innerObj = {};
            for(skillName in StringConstants.PRIMARY_SKILLS) {
                Reflect.setField(innerObj, skillName, parserData[pos++]);
            }
            Reflect.setField(entry, "lowLevelChance", innerObj);

            innerObj = {};
            for(skillName in StringConstants.PRIMARY_SKILLS) {
                Reflect.setField(innerObj, skillName, parserData[pos++]);
            }
            Reflect.setField(entry, "highLevelChance", innerObj);

            innerObj = {};
            for(skillName in StringConstants.SECONDARY_SKILLS_NAMES) {
                Reflect.setField(innerObj, skillName, parserData[pos++]);
            }
            Reflect.setField(entry, "secondarySkills", innerObj);

            innerObj = {};
            for(skillName in StringConstants.TOWN_TYPE) {
                Reflect.setField(innerObj, skillName, parserData[pos++]);
            }
            Reflect.setField(entry, "tavern", innerObj);

            h3Data.push(entry);
        }

        return h3Data;
    }
}