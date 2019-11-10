package lib.mapping;

import data.ConfigData;

typedef TVPVector = Array<TerrainViewPattern>;

using Reflect;
using StringTools;

class TerrainViewPatternConfig {
    private static inline var TER_GROUPS:Map<String, TerrainGroup> = [
        "normal" => TerrainGroup.NORMAL,
        "dirt" => TerrainGroup.DIRT,
        "sand" => TerrainGroup.SAND,
        "water" => TerrainGroup.WATER,
        "rock" => TerrainGroup.ROCK
    ];

    private var terrainViewPatterns:Map<TerrainGroup, Array<TVPVector>>;
    private var terrainTypePatterns:Map<String, TVPVector>;

    public function new() {
        terrainViewPatterns = new Map<TerrainGroup, Array<TVPVector>>();
        terrainTypePatterns = new Map<String, TVPVector>();

        var config:Dynamic = ConfigData.data.get("config/terrainViewPatterns.json");
        var patternTypes = ["terrainView", "terrainType"];
        for(patternType in patternTypes) {
            var patternsVec:Array<Dynamic> = config.field(patternType);

            for(ptrnNode in patternsVec) {
                var pattern = new TerrainViewPattern();
                // Read pattern data
                var data:Array<String> = ptrnNode.field("data");
                for(cell in data) {
                    cell = cell.replace(" ", "");
                    var rules:Array<String> = cell.split(",");
                    for(ruleStr in rules) {
                        var ruleParts = ruleStr.split("-");
                        var rule = new WeightedRule(ruleParts[0]);
                        if(ruleParts.length > 1) {
                            rule.points = Std.parseInt(ruleParts[1]);
                        }
                        pattern.data[j].push(rule);
                    }
                }

                // Read various properties
                pattern.id = ptrnNode.field("id");
                pattern.minPoints = ptrnNode.hasField("minPoints") ? ptrnNode.field("minPoints") : 0;
                if(ptrnNode.hasField("maxPoints")) {
                    pattern.maxPoints = ptrnNode.field("maxPoints");
                }

                // Read mapping
                if(patternType == patternTypes[0]) {
                    var mappingStruct = ptrnNode.field("mapping");
                    for(field in mappingStruct.fields()) {
                        var terGroupPattern = new TerrainViewPattern();
                        var mappingStr = (mappingStruct.field(field):String).replace(" ");
                        var colonIndex = mappingStr.indexOf(":");
                        var flipMode = mappingStr.substr(0, colonIndex);
                        terGroupPattern.diffImages = TerrainViewPattern.FLIP_MODE_DIFF_IMAGES == flipMode.charAt(flipMode.length - 1);
                        if(terGroupPattern.diffImages) {
                            terGroupPattern.rotationTypesCount = Std.parseInt(flipMode.substr(0, flipMode.length() - 1));
                        }
                        mappingStr = mappingStr.substr(colonIndex + 1);
                        var mappings:Array<String> = mappingStr.split(",");
                        for(mapping in mappings) {
                            var range:Array<String> = mapping.split("-");
                            terGroupPattern.mapping.push({lowerRange: Std.parseInt(range[0]), upperRange: Std.parseInt(range.length > 1 ? range[1] : range[0])});
                        }

                        // Add pattern to the patterns map
                        var terGroup = getTerrainGroup(field);
                        var terrainViewPatternFlips:Array<TerrainViewPattern> = [];
                        terrainViewPatternFlips.push(terGroupPattern);

                        for (i in 1...4) {
                            //auto p = terGroupPattern;
                            flipPattern(terGroupPattern, i); //FIXME: we flip in place - doesn't make much sense now, but used to work
                            terrainViewPatternFlips.push(terGroupPattern);
                        }
                        if(!terrainViewPatterns.exists(terGroup)) {
                            terrainViewPatterns.set(terGroup, []);
                        }
                        terrainViewPatterns.get(terGroup).push(terrainViewPatternFlips);
                    }
                } else if (patternType == patternTypes[1]) {
                    if(!terrainViewPatterns.exists(pattern.id)) {
                        terrainViewPatterns.set(pattern.id, []);
                    }
                    terrainTypePatterns.get(pattern.id).push(pattern);
                    for (i in 1...4) {
                        flipPattern(pattern, i); ///FIXME: we flip in place - doesn't make much sense now
                        terrainTypePatterns[pattern.id].push(pattern);
                    }

                }
            }


        }
    }

    public inline function getTerrainGroup(terGroup:String):TerrainGroup {
        return TER_GROUPS.get(terGroup);
    }

    public function flipPattern(pattern:TerrainViewPattern, flip:Int) {
        function swap<T>(data:Array<T>, p1:Int, p2:Int) {
            var temp:T = data[p1];
            data[p1] = data[p2];
            data[p2] = temp;
        }
        //flip in place to avoid expensive constructor. Seriously.
        if (flip == 0) {
            return;
        }

        //always flip horizontal
        for (i in 0...3) {
            var y = i * 3;
            swap(pattern.data[y], pattern.data[y + 2]);
        }
        //flip vertical only at 2nd step
        if (flip == MapOperation.FLIP_PATTERN_VERTICAL) {
            for (i in 0...3) {
                swap(pattern.data[i], pattern.data[6 + i]);
            }
        }
    }
}
