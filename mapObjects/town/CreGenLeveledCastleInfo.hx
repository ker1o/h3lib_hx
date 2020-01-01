package lib.mapObjects.town;

class CreGenLeveledCastleInfo extends SpecObjInfo {
    public var castleInfo:CreGenAsCastleInfo;
    public var leveldInfo:CreGenLeveledInfo;

    public function new() {
        super();

        castleInfo = new CreGenAsCastleInfo();
        leveldInfo = new CreGenLeveledInfo();
    }
}
