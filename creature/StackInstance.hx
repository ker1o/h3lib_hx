package lib.creature;

import constants.id.CreatureId;
import lib.herobonus.BonusSystemNodeType;
import lib.mapObjects.ArmedInstance;
import lib.artifacts.ArtifactSet;
import lib.herobonus.BonusSystemNode;
import lib.mod.VLC;

class StackInstance extends BonusSystemNode {
    // composition instead of inheritance
    public var stackBasicDescriptor:StackBasicDescriptor;
    public var artifactSet:ArtifactSet;

    // hlp variable used during loading map, when object (hero or town) have creatures that must have same alignment.
    // idRand < 0 -> normal, non-random creature
    // idRand / 2 -> level
    // idRand % 2 -> upgrade number
    public var idRand:Int;

    public var armyObj:ArmedInstance; //stack must be part of some army, army must be part of some object
    public var experience:Int;//commander needs same amount of exp as hero

    private var _armyObj:ArmedInstance;

    public function new(creatureId:CreatureId, creature:Creature = null, count:Int = 0) {
        super();
        stackBasicDescriptor = new StackBasicDescriptor();
        artifactSet = new ArtifactSet();

        init();
    }

    private function init() {
        experience = 0;
        stackBasicDescriptor.count = 0;
        stackBasicDescriptor.type = null;
        idRand = -1;
        _armyObj = null;
        setNodeType(BonusSystemNodeType.STACK_INSTANCE);
    }

    private function setTypeByCreatureId(creId:CreatureId) {
        if(((creId:Int) >= 0) && ((creId:Int) < VLC.instance.creh.creatures.length)) {
            setTypeByCreature(VLC.instance.creh.creatures[creId]);
        } else {
            setTypeByCreature(null);
        }
    }

    private function setTypeByCreature(c:Creature) {
        if(stackBasicDescriptor.type != null) {
            detachFrom(stackBasicDescriptor.type);
            if (stackBasicDescriptor.type.isMyUpgrade(c) && VLC.instance.modh.modules.STACK_EXP) {
                experience = Std.int(experience * VLC.instance.creh.expAfterUpgrade / 100.0);
            }
        }

        stackBasicDescriptor.setType(c);

        if(stackBasicDescriptor.type != null) {
            attachTo(stackBasicDescriptor.type);
        }
    }

    public function getExpRank():Int {
        if (!VLC.instance.modh.modules.STACK_EXP) {
            return 0;
        }
        var tier:Int = stackBasicDescriptor.type.level;
        if ((1 <= tier) && (tier <= 7)) {
            var i = VLC.instance.creh.expRanks[tier].length - 2;
            while (i >-1) {//sic!
                //exp values vary from 1st level to max exp at 11th level
                if (experience >= VLC.instance.creh.expRanks[tier][i]) {
                    return ++i; //faster, but confusing - 0 index mean 1st level of experience
                }
                i--;
            }
            return 0;
        } else {//higher tier
            var i = VLC.instance.creh.expRanks[0].length - 2;
            while (i >-1) {
                if (experience >= VLC.instance.creh.expRanks[0][i]) {
                    return ++i;
                }
                i--;
            }
            return 0;
        }
    }
}
