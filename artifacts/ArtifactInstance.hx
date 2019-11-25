package lib.artifacts;

import constants.GameConstants;
import constants.ArtifactPosition;
import lib.netpacks.ArtifactLocation;
import lib.herobonus.BonusSystemNode;
import lib.herobonus.BonusSource;
import lib.herobonus.BonusDuration;
import constants.ArtifactId;
import lib.spells.Spell;
import lib.herobonus.BonusType;
import lib.herobonus.Bonus;
import lib.mod.VLC;
import constants.SpellId;
import mapping.MapBody;
import constants.id.ArtifactInstanceID;

class ArtifactInstance extends BonusSystemNode {
    public var artType:Artifact;
    public var id:ArtifactInstanceID;

    public function new(art:Artifact = null) {
        super();
        init();
        setType(art);
    }

    private function init() {
        id = new ArtifactInstanceID((ArtifactId.NONE:Int)); //to be randomized
        setNodeType(ARTIFACT_INSTANCE);
    }

    public function setType(art:Artifact) {
        artType = art;
        attachTo(art);
    }

    public function canBePutAt(al:ArtifactLocation, assumeDestRemoved:Bool = false):Bool {
        return canBePutAtPosition(al.getHolderArtSet(), al.slot, assumeDestRemoved);
    }

    public function canBePutAtPosition(artSet:ArtifactSet, slot:ArtifactPosition, assumeDestRemoved:Bool) {
        if((slot:Int) >= GameConstants.BACKPACK_START) {
            if(artType.isBig()) {
                return false;
            }
            //TODO backpack limit
            return true;
        }

        var possibleSlots:Array<ArtifactPosition> = null;
        if(!artType.possibleSlots.exists(artSet.bearerType())) {
//            logMod->warn("Warning: artifact %s doesn't have defined allowed slots for bearer of type %s", artType->Name(), artSet->bearerType());
            return false;
        } else {
            possibleSlots = artType.possibleSlots.get(artSet.bearerType());
        }

        if (possibleSlots.indexOf(slot) == -1) {
            return false;
        }

        return artSet.isPositionFree(slot, assumeDestRemoved);
    }

    public static function createArtifact(map:MapBody, aid:Int, spellID:Int = SpellId.NONE):ArtifactInstance {
        var a:ArtifactInstance = null;
        if(aid >= 0) {
            if(spellID < 0) {
                a = ArtifactInstance.createNewArtifactInstanceById(aid);
            } else {
                a = ArtifactInstance.createScroll((spellID:SpellId).toSpell());
            }
        } else {//FIXME: create combined artifact instance for random combined artifacts, just in case
            a = new ArtifactInstance(); //random, empty
        }

        map.addNewArtifactInstance(a);

        //TODO make it nicer
        // ToDo: check if it works
        if(a.artType != null && (a.artType.constituents != null)) {
            var comb:CombinedArtifactInstance = cast a;
            for(ci in comb.constituentsInfo) {
                map.addNewArtifactInstance(ci.art);
            }
        }
        return a;
    }

    public static function createNewArtifactInstanceById(aid:Int):ArtifactInstance {
        return createNewArtifactInstance(VLC.instance.arth.artifacts[aid]);
    }

    public static function createNewArtifactInstance(art:Artifact):ArtifactInstance {
        if(art.constituents != null) {
            var ret = new ArtifactInstance(art);
            var growingArtifact:GrowingArtifact = cast art;
            if (growingArtifact != null) {
                var bonus = new Bonus();
                bonus.type = BonusType.LEVEL_COUNTER;
                bonus.val = 0;
                ret.addNewBonus(bonus);
            }
            return ret;
        } else {
            var ret = new CombinedArtifactInstance(art);
            ret.createConstituents();
            return ret;
        }
    }

    public static function createScroll(s:Spell):ArtifactInstance {
        return createScrollById(s.id);
    }

    public static function createScrollById(sid:SpellId):ArtifactInstance {
        var ret = new ArtifactInstance(VLC.instance.arth.artifacts[ArtifactId.SPELL_SCROLL]);
        var b = new Bonus(BonusDuration.PERMANENT, BonusType.SPELL, BonusSource.ARTIFACT_INSTANCE, -1, ArtifactId.SPELL_SCROLL, sid);
        ret.addNewBonus(b);
        return ret;
    }

    public function putAt(al:ArtifactLocation) {
        al.getHolderArtSet().setNewArtSlot(al.slot, this, false);
        if((al.slot:Int) < GameConstants.BACKPACK_START) {
            al.getHolderNode().attachTo(this);
        }
    }

}
