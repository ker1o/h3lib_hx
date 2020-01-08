package mapping;

import haxe.io.Bytes;
import filesystem.InputStream;

class MapLoaderJson implements IMapLoader {

    private var _stream:Bytes;

    public function new(stream:Bytes) {
        _stream = stream;
    }

    public function loadMapHeader():MapHeader {
        return new MapHeader();
    }

    public function loadMap():MapBody {
        return new MapBody();
    }

}
