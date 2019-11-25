package lib.mapObjects.town;

import constants.CreatureType;

private typedef CreaturesSet = Array<{id:Int, creatures:Array<CreatureType>}>;

class GDwelling extends ArmedInstance {
    public var info:SpecObjInfo; //random dwelling options; not serialized
    public var creatures:CreaturesSet; //creatures[level] -> <vector of alternative ids (base creature and upgrades, creatures amount>

    public function new() {
        super();
    }
}
