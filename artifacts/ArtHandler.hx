package lib.artifacts;

import data.H3mConfigData;
import haxe.Json;
import lib.mod.IHandlerBase;

class ArtHandler implements IHandlerBase {
    //tmp vectors!!! do not touch if you don't know what you are doing!!!
    public var treasures:Array<Artifact>;
    public var minors:Array<Artifact>;
    public var majors:Array<Artifact>;
    public var relics:Array<Artifact>;

    public var artifacts:Array<Artifact>;
    public var allowedArtifacts:Array<Artifact>;
    public var growingArtifacts:Array<Artifact>;
    
    public function new() {
    }

    public function loadObject(scope:String, name:String, data:Dynamic, index:UInt = 0) {
    }

    public function loadLegacyData(dataSize:Int):Array<Dynamic> {
        artifacts = [];
        var h3Data:Array<Dynamic> = [];

        var classes = [
            "S" => "SPECIAL",
            "T" => "TREASURE",
            "N" => "MINOR",
            "J" => "MAJOR",
            "R" => "RELIC"
        ];
        var artSlots = ["SPELLBOOK", "MACH4", "MACH3", "MACH2", "MACH1", "MISC5", "MISC4", "MISC3", "MISC2", "MISC1", "FEET", "LEFT_RING", "RIGHT_RING", "TORSO", "LEFT_HAND", "RIGHT_HAND", "NECK", "SHOULDERS", "HEAD"];

        var parser:Array<Array<Dynamic>> = Json.parse(H3mConfigData.data.get("DATA/ARTRAITS.TXT"));
        var events:Array<String> = Json.parse(H3mConfigData.data.get("DATA/ARTEVENT.TXT"));

        for(i in 0...dataSize) {
            var parserData = parser[i];
            var artData = {};
            var pos:Int = 0;
            var text = {name: parserData[pos++], event: events[i]};
            Reflect.setField(artData, "value", parserData[pos++]);

            var slotData:Array<String> = [];
            for(artSlot in artSlots) {
                if(parserData[pos++] == true) {
                    slotData.push(artSlot);
                }
            }

            Reflect.setField(artData, "slot", slotData);
            Reflect.setField(artData, "class", classes.get(parserData[pos++]));
            Reflect.setField(artData, "description", parserData[pos++]);
            Reflect.setField(artData, "text", text);

            h3Data.push(artData);
        }

        return h3Data;
    }

}
