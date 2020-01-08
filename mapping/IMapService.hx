package lib.mapping;

import haxe.io.Bytes;

interface IMapService {
//    function loadMap(bytes:Bytes, size:Int, name:String):Map;
//    function loadMapHeader(bytes:Bytes, size:Int, name:String):MapHeader;

    function loadMapByName(name:String):MapBody;
    function loadMapHeaderByName(name:String):MapHeader;
}
