package lib.mapObjects.town;

class CreGenAsCastleInfo extends SpecObjInfo {
    public var asCastle:Bool;
    public var identifier:Int;//h3m internal identifier
    public var allowedFactions:Array<Bool>;
    public var instanceId:String;//vcmi map instance identifier

    public function new() {
        super();
    }
}
