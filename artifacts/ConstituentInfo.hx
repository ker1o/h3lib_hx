package lib.artifacts;

import lib.constants.ArtifactPosition;

class ConstituentInfo {
    public var art:ArtifactInstance;
    public var slot:ArtifactPosition;

    public function new(art:ArtifactInstance = null, slot:ArtifactPosition = ArtifactPosition.PRE_FIRST) {
        this.art = art;
        this.slot = slot;
    }
}
