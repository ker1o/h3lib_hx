package lib.filesystem;

import haxe.io.Bytes;

class BinaryReader {

    private var bytes:Bytes;

    private var pos:Int;

    public function new(bytes:Bytes) {
        this.bytes = bytes;
        pos = 0;
    }

    public function readUInt32():Int {
        var i = bytes.getInt32(pos);
        pos += 4;
        return i;
    }

    public function readBool():Bool {
        var b = bytes.get(pos);
        pos++;
        return b != 0;
    }

    public function readInt8():Int {
        var i = bytes.get(pos);
        pos++;
        return i;
    }

    public function readUInt8():Int {
        var i = bytes.get(pos);
        pos++;
        return i;
    }

    public function readUInt16():Int {
        var i = bytes.getUInt16(pos);
        pos += 2;
        return i;
    }

    public function readString():String {
        var len = readUInt32();
        if(len > 500000) {
            throw 'BinaryReader.readString(): string is too long ($len)';
        }
        var str = bytes.getString(pos, len);
        pos += len;
        if(!isValidUnicode(str)) {
            return toUnicode(str);
        }
        return str;
    }

    private function isValidUnicode(str:String):Bool {
        for(i in 0...str.length) {
            if(str.charCodeAt(i) > 0x80) {
               return false;
            }
        }
        return true;
    }

    private inline function toUnicode(str:String):String {
        //TBD?
        return str;
    }

    public function seek(position:Int) {
        pos = position;
    }

    public function skip(count:Int) {
        pos += count;
    }

}
