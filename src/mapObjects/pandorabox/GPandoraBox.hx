package mapObjects.pandorabox;

import creature.CreatureSet;
import constants.ArtifactId;
import constants.SecondarySkill;
import constants.SpellId;
import creature.Creature.Resources;
import mapObjects.ArmedInstance;

class GPandoraBox extends ArmedInstance {
    public var message:String;
    public var hasGuardians:Bool; //helper - after battle even though we have no stacks, allows us to know that there was battle

    //gained things:
    public var gainedExp:UInt;
    public var manaDiff:Int; //amount of gained / lost mana
    public var moraleDiff:Int; //morale modifier
    public var luckDiff:Int; //luck modifier
    public var resources:Resources; //gained / lost resources
    public var primskills:Array<Int>; //gained / lost prim skills
    public var abilities:Array<SecondarySkill>; //gained abilities
    public var abilityLevels:Array<Int>; //levels of gained abilities
    public var artifacts:Array<ArtifactId>; //gained artifacts
    public var spells:Array<SpellId>; //gained spells
    public var creatures:CreatureSet; //gained creatures

    public function new() {
        super();

        resources = new Resources();
        hasGuardians = false;
        gainedExp = 0;
        manaDiff = 0;
        moraleDiff = 0;
        luckDiff = 0;

        primskills = [];
    }
}
