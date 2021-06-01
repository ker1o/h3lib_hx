package mapObjects.misc;

import mapObjects.GObjectInstance;
import UInt;
import constants.id.TeleportChannelId;

class GSubterraneanGate extends GMonolith {

    public function new() {
        super();
    }

    //matches subterranean gates into pairs
    public static function postInit() {
        //split on underground and surface gates
        var gatesSplit:Array<Array<GSubterraneanGate>> = [[], []]; //surface and underground gates
        for (obj in GObjectInstance.cb.gameState().map.objects) {
            if(obj == null) // FIXME: Find out why there are nullptr objects right after initialization
                continue;

            var objInstance = GObjectInstance.cb.gameState().getObjInstance(obj.id);
            var hlp = Std.isOfType(objInstance, GSubterraneanGate) ? cast(objInstance, GSubterraneanGate) : null;
            if (hlp != null)
                gatesSplit[hlp.pos.z].push(hlp);
        }

        //sort by position
        gatesSplit[0].sort(function(a:GObjectInstance, b:GObjectInstance) {
            return a.pos.equals(b.pos) ? 0 :
                a.pos.less(b.pos) ? -1 : 1;
        });

        var assignToChannel = function(obj:GSubterraneanGate) {
            if (obj.channel == new TeleportChannelId())	{
                // if object not linked to channel then create new channel
                var channelsSize = Lambda.count({iterator: GObjectInstance.cb.gameState().map.teleportChannels.iterator});
                obj.channel = new TeleportChannelId(channelsSize);
                addToChannel(GObjectInstance.cb.gameState().map.teleportChannels, obj);
            }
        };

        for (i in 0...gatesSplit[0].length) {
            var objCurrent:GSubterraneanGate = gatesSplit[0][i];

            //find nearest underground exit
            var best = {posInVector: -1, distance: 2147483647}; //pair<pos_in_vector, distance^2>
            for(j in 0...gatesSplit[1].length) {
                var checked = gatesSplit[1][j];
                if (checked.channel != new TeleportChannelId()) {
                    continue;
                }
                var hlp = checked.pos.dist2dSQ(objCurrent.pos);
                if (hlp < best.distance) {
                    best.posInVector = j;
                    best.distance = hlp;
                }
            }

            assignToChannel(objCurrent);
            if (best.posInVector >= 0) { //found pair
                gatesSplit[1][best.posInVector].channel = objCurrent.channel;
                addToChannel(GObjectInstance.cb.gameState().map.teleportChannels, gatesSplit[1][best.posInVector]);
            }
        }

        // we should assign empty channels to underground gates if they don't have matching overground gates
        for (i in 0...gatesSplit[1].length) {
            assignToChannel(gatesSplit[1][i]);
        }
    }

    static function addToChannel(channelsList:Map<TeleportChannelId, TeleportChannel>, obj:GTeleport) {
        var tc:TeleportChannel;
        if (!channelsList.exists(obj.channel)) {
            tc = new TeleportChannel();
            channelsList[obj.channel] = tc;
        } else {
            tc = channelsList[obj.channel];
        }

        if (obj.isEntrance() && tc.entrances.indexOf(obj.id) == -1) {
            tc.entrances.push(obj.id);
        }

        if (obj.isExit() && tc.exits.indexOf(obj.id) == -1) {
            tc.exits.push(obj.id);
        }

        if (tc.entrances.length > 0 && tc.exits.length > 0 && (tc.entrances.length != 1 || tc.entrances != tc.exits)) {
            tc.passability = Passability.PASSABLE;
        }
    }
}
