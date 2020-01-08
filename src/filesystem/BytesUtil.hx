package filesystem;

import haxe.io.Bytes;

class BytesUtil {

    public static function resize(bytesIn:Bytes, newLength:Int):Bytes {
        var bytesOut = Bytes.alloc(newLength);
        bytesOut.blit(0, bytesIn, 0, Std.int(Math.min(newLength, bytesIn.length)));
        return bytesOut;
    }

}
