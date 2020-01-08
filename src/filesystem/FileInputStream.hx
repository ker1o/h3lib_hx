package filesystem;

import haxe.io.Bytes;

class FileInputStream extends InputStream {
    private var dataStart:Int;
    private var dataSize:Int;
    private var fileBytes:Bytes;

    private var pos:Int;

    public function new(fileBytes:Bytes, start:Int = 0, size:Int = 0) {
        super();
        this.fileBytes = fileBytes;
        this.dataStart = start;
        this.dataSize = size == 0 ? fileBytes.length : size;

        pos = start;
    }

    public function tell():Int {
        return pos - dataStart;
    }

    override public function getSize():Int {
        return dataSize;
    }

    override public function seek(position:Int):Int {
        pos = dataStart + Std.int(Math.min(position, dataSize));
        return tell();
    }

    override public function read(data:Bytes, size:Int):Int {
        var origin = tell();
        var toRead = Std.int(Math.min(dataSize - origin, size));
        data.blit(0, fileBytes, pos, toRead);
        pos += toRead;
        return toRead;
    }

}
