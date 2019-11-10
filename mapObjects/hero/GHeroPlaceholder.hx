package lib.mapObjects.hero;

class GHeroPlaceholder extends GObjectInstance {
    //subID stores id of hero type. If it's 0xff then following field is used
    public var power:Int;

    public function new() {
        super();
    }
}
