package lib.mapObjects.constructors;

import lib.creature.Creature;
import lib.mapObjects.town.GDwelling;

class DwellingInstanceConstructor extends DefaultObjectTypeHandler<GDwelling> {
    private var availableCreatures:Array<Array<Creature>>;
    private var guards:Dynamic;

    public function new() {
        super(GDwelling);
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
}
