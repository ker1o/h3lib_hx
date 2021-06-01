package mapObjects.constructors;

import mod.VLC;
import creature.Creature;
import mapObjects.town.GDwelling;

using Reflect;

class DwellingInstanceConstructor extends DefaultObjectTypeHandler<GDwelling> {
    private var availableCreatures:Array<Array<Creature>>;
    private var guards:Dynamic;

    public function new() {
        super(GDwelling);

        availableCreatures = [];
    }

    override public function create(objTempl:ObjectTemplate):GObjectInstance {
        var obj:GDwelling = createTyped(objTempl);

        for (entry in availableCreatures) {
            for (cre in entry) {
                obj.creatures[obj.creatures.length - 1].creatures.push(cre.idNumber);
            }
        }
        return obj;
    }

    public function producesCreature(crea:Creature) {
        for (entry in availableCreatures) {
            for (cre in entry) {
                if (crea == cre) {
                    return true;
                }
            }
        }
        return false;
    }

    override function initTypeData(input:Dynamic) {
        var levels:Array<Dynamic> = input.field("creatures");
        var totalLevels:Int = levels != null ? levels.length : 0;

        availableCreatures.resize(totalLevels);
        for (currentLevel in 0...totalLevels) {
            var creaturesOnLevel:Array<Dynamic> = levels[currentLevel];
            var creaturesNumber = creaturesOnLevel.length;
            availableCreatures[currentLevel] = [];
            availableCreatures[currentLevel].resize(creaturesNumber);

            for (currentCreature in 0...creaturesNumber ){
                var name = creaturesOnLevel[currentCreature];
                var meta = "core";
                VLC.instance.modh.identifiers.requestIdentifierByNodeName("creature", name, meta, function(index:Int) {
                    availableCreatures[currentLevel][currentCreature] = VLC.instance.creh.creatures[index];
                });
            }
            //assert(!availableCreatures[currentLevel].empty());
        }
        guards = input.field("guards");
    }
}
