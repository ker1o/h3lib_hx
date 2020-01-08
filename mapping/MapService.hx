package lib.mapping;

import lib.filesystem.FileInputStream;
import lib.filesystem.FileInputStream;
import lib.filesystem.FileCache;
import lib.filesystem.CompressedStream;
import lib.filesystem.BinaryReader;
import haxe.io.Bytes;

class MapService implements IMapService {
    public function new() {
    }

//    public function loadMap(buffer:Bytes, size:Int, name:String):Map {
//        var mapLoader = getMapLoader(buffer);
//        return new Map();
//    }

    public function loadMapByName(name:String):MapBody {
        var stream = getStreamFromFs(name);
        return getMapLoader(stream).loadMap();
    }

    public function loadMapHeaderByName(name:String):MapHeader {
        var stream = getStreamFromFs(name);
        return getMapLoader(stream).loadMapHeader();
    }


    private function getStreamFromFs(name:String):Bytes {
        return FileCache.instance.getMap(name);
    }

//    private function getStreamFromMem(bytes:Bytes, size:Int):InputStream {
//        return new MemoryStream(bytes, size);
//    }

    private function getMapLoader(stream:Bytes):IMapLoader {
        var reader = new BinaryReader(stream);
        var header = reader.readUInt32();
        reader.seek(0);

        switch(header) {
            case 0x06054b50 | 0x04034b50 | 0x02014b50:
                return new MapLoaderJson(stream);
            default:
                switch(header & 0xffffff) {
                    case 0x00088B1F:
                        var compressed = new CompressedStream(new FileInputStream(stream), true);
                        return new MapLoaderH3M(compressed.readAll().data);
                    case MapFormat.WOG | MapFormat.AB | MapFormat.ROE | MapFormat.SOD:
                        return new MapLoaderH3M(stream);
                    default:
                        throw '$header is not supported map format';
                }

        }

    }
}
