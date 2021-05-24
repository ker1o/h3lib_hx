package netpacks;

import constants.id.PlayerColor;

class InfoWindow extends PackForClient {
    public var text:String;
    public var components:Array<Component>;
    public var player:PlayerColor;
    public var soundID:Int = 0;

    public function new() {
        super();
    }
}