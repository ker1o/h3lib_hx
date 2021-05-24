package netpacks;

import constants.id.ObjectInstanceId;
import utils.Int3;
import constants.id.TeleportChannelId;
import constants.id.PlayerColor;

class TeleportDialog {
    public var player:PlayerColor;
    public var channel:TeleportChannelId;
    public var exits:TeleportExitsList;
    public var impassable:Bool;

    public function new(player:PlayerColor, channel:TeleportChannelId) {
        this.player = player;
        this.channel = channel;
    }
}

typedef TeleportExitsList = Array<{obj:ObjectInstanceId, pos:Int3}>;