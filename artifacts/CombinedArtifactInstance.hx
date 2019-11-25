package lib.artifacts;

import constants.ArtifactPosition;

class CombinedArtifactInstance extends ArtifactInstance {

    public var constituentsInfo:Array<ConstituentInfo>;

    public function new(art:Artifact) {
        super(art);
    }

    public function createConstituents() {
        for(art in artType.constituents) {
            addAsConstituent(ArtifactInstance.createNewArtifactInstanceById(art.id), ArtifactPosition.PRE_FIRST);
        }
    }

    public function addAsConstituent(art:ArtifactInstance, slot:ArtifactPosition) {
        constituentsInfo.push(new ConstituentInfo(art, slot));
        attachTo(art);
    }
}
