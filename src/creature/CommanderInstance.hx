package creature;

import artifacts.Artifact.ArtBearer;
import constants.CommanderSecondarySkills;
import herobonus.BonusSystemNodeType;
import constants.id.CreatureId;

class CommanderInstance extends StackInstance {
    //TODO: what if Commander is not a part of creature set?

    //commander class is determined by its base creature
    public var alive:Int; //maybe change to bool when breaking save compatibility?
    public var level:Int; //required only to count callbacks
    public var name:String; // each Commander has different name
    public var secondarySkills:Array<Int> = []; //ID -> level
    public var specialSKills:Array<Int> = [];

    public function new(id:CreatureId) {
        super();
        init();
        setTypeByCreatureId(id);
        name = "Commando"; //TODO - parse them
        artifactSet.bearerType = bearerType;
    }

    override function init() {
        super.init();

        alive = 1;
        experience = 0;
        level = 1;
        stackBasicDescriptor.count = 1;
        stackBasicDescriptor.type = null;
        idRand = -1;
        _armyObj = null;
        setNodeType(BonusSystemNodeType.COMMANDER);
        secondarySkills.resize(CommanderSecondarySkills.SPELL_POWER + 1);
    }

    public function giveStackExp(exp:Int) {
        if (alive > 0)
            experience += exp;
    }

    override public function bearerType():ArtBearer {
        return ArtBearer.COMMANDER;
    }
}