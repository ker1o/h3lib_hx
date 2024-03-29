package artifacts;

import artifacts.Artifact.ArtBearer;
import constants.GameConstants;
import constants.ArtifactPosition;

class ArtifactSet {
    //hero's artifacts from bag
    public var artifactsInBackpack:Array<ArtSlotInfo>;

    //map<position,artifact_id>; positions: 0 - head; 1 - shoulders; 2 - neck; 3 - right hand; 4 - left hand; 5 - torso; 6 - right ring; 7 - left ring; 8 - feet; 9 - misc1; 10 - misc2; 11 - misc3; 12 - misc4; 13 - mach1; 14 - mach2; 15 - mach3; 16 - mach4; 17 - spellbook; 18 - misc5
    public var artifactsWorn:Map<ArtifactPosition, ArtSlotInfo>;

    public var bearerType:Void->ArtBearer;
    public var putArtifact:ArtifactPosition->ArtifactInstance->Void;

    public function new() {
        artifactsInBackpack = [];
        artifactsWorn = new Map<ArtifactPosition, ArtSlotInfo>();
    }

    public function eraseArtSlot(slot:ArtifactPosition) {
        if((slot:Int) < GameConstants.BACKPACK_START) {
            artifactsWorn.remove(slot);
        } else {
            slot = slot - GameConstants.BACKPACK_START;
            artifactsInBackpack.splice(slot, 1);
        }
    }

    public function retrieveNewArtSlot(slot:ArtifactPosition):ArtSlotInfo {
        var ret:ArtSlotInfo = null;
        if((slot:Int) < GameConstants.BACKPACK_START) {
            ret = artifactsWorn[slot];
        } else {
            ret = new ArtSlotInfo();
            artifactsInBackpack.insert(slot - GameConstants.BACKPACK_START, ret);
        }
        return ret;
    }

    public function setNewArtSlot(slot:ArtifactPosition, art:ArtifactInstance, locked:Bool) {
        var asi:ArtSlotInfo = retrieveNewArtSlot(slot);

        // ToDo: check if it's ok
        if (asi != null) {
            asi.artifact = art;
            asi.locked = locked;
        }
    }

    public function isPositionFree(pos:ArtifactPosition, onlyLockCheck:Bool):Bool {
        var s:ArtSlotInfo = getSlot(pos);
        if(s != null) {
            return (onlyLockCheck || s.artifact == null) && !s.locked;
        }

        return true; //no slot means not used
    }

    public function getSlot(pos:ArtifactPosition):ArtSlotInfo {
        if(artifactsWorn.exists(pos)) {
            return artifactsWorn.get(pos);
        }
        if((pos:Int) >= ArtifactPosition.AFTER_LAST) {
            var backpackPos:Int = (pos:Int) - GameConstants.BACKPACK_START;
            if(backpackPos < 0 || backpackPos >= artifactsInBackpack.length) {
                return null;
            } else {
                return artifactsInBackpack[backpackPos];
            }
        }

        return null;
    }

    public function getArt(pos:ArtifactPosition, excludeLocked:Bool = false) {
        var si:ArtSlotInfo = getSlot(pos);
        if (si != null) {
            if (si.artifact != null && (!excludeLocked || !si.locked))
                return si.artifact;
        }

        return null;
    }
}
