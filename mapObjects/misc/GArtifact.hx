package lib.mapObjects.misc;

import mapping.MapBody;
import constants.Obj;
import lib.artifacts.ArtifactInstance;

class GArtifact extends ArmedInstance {
    public var storedArtifact:ArtifactInstance;
    public var message:String;

    public function new() {
        super();
    }

    override public function afterAddToMap(map:MapBody) {
        if (ID == Obj.SPELL_SCROLL && storedArtifact != null && storedArtifact.id.getNum() < 0) {
            map.addNewArtifactInstance(storedArtifact);
        }
    }
}
