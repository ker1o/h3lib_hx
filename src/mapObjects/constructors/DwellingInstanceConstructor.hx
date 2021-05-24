package mapObjects.constructors;

import creature.Creature;
import mapObjects.town.GDwelling;

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
}
