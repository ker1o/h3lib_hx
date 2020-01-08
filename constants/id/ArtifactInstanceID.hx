package lib.constants.id;

@:forward(getNum)
abstract ArtifactInstanceID(BaseForId) {
    public function new(num:Int) {
        this = num;
    }
}
