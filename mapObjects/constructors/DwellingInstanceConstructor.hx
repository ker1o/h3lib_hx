package lib.mapObjects.constructors;

import lib.creature.Creature;
import lib.mapObjects.town.GDwelling;

class DwellingInstanceConstructor extends DefaultObjectTypeHandler<GDwelling> {
    private var availableCreatures:Array<Array<Creature>>;
    private var guards:Dynamic;

    public function new() {
        super();
    }
}
