package lib.artifacts;

class ArtSlotInfo {
    public var artifact:ArtifactInstance;
    public var locked:Bool = false; //if locked, then artifact points to the combined artifact

    public function new() {
    }
}
