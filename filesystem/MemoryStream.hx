package lib.filesystem;

import haxe.io.Bytes;

class MemoryStream extends InputStream {
    public var data(default, null):Bytes;

    private var _size:Int;
    private var _position:Int;

    public function new(data:Bytes, size:Int) {
        super();

        this.data = data;
        _size = size;
        _position = 0;
    }

    override public function read(data:Bytes, size:Int):Int {
        var toRead:Int = Std.int(Math.min(_size - tell(), size));
        data.blit(0, this.data, _position, toRead);
        _position += size;
        return toRead;
    }

    override public function seek(position:Int):Int {
        var origin = tell();
        _position = Std.int(Math.min(position, _size));
        return tell() - origin;
    }

    public function tell():Int {
        return _position;
    }

    override public function getSize():Int {
        return _size;
    }


}
