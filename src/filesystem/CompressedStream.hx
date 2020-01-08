package filesystem;

import haxe.io.UInt8Array;
import haxe.io.Bytes;
import pako.zlib.Constants.Flush;
import pako.zlib.Constants.ErrorStatus;
import pako.zlib.Inflate;
import pako.zlib.ZStream;

class CompressedStream extends BufferedStream {

    public static var inflateBlockSize = 10000;

    private var gzipStream:InputStream;
    private var compressedBuffer:Bytes;
    private var inflateState:ZStream;

    public function new(stream:InputStream, gzip:Bool, decompressedSize:Int = 0) {
        super(decompressedSize);
        gzipStream = stream;
        compressedBuffer = Bytes.alloc(inflateBlockSize);

        inflateState = new ZStream();

        var wbits = 15;
        if (gzip) {
            wbits += 16;
        }

        var ret:Int = Inflate.inflateInit2(inflateState, wbits);
        if(ret != ErrorStatus.Z_OK) {
            throw "Failed to initialize inflate";
        }
    }

    override public function readMore(data:UInt8Array, size:Int):Int {
        if (inflateState == null) {
            return 0;
        }

        var fileEnded = false;
        var endLoop = false;

        var decompressed = inflateState.total_out;
        inflateState.avail_out = size;
        inflateState.output = data;

        do {
            if (inflateState.avail_in == 0) {
                var availSize = gzipStream.read(compressedBuffer, compressedBuffer.length);

                if (availSize != compressedBuffer.length) {
                    gzipStream = null;
                }
                inflateState.avail_in = availSize;
                inflateState.input = UInt8Array.fromBytes(compressedBuffer);
                inflateState.next_in = 0;
            }

            var ret:Int = Inflate.inflate(inflateState, Flush.Z_NO_FLUSH);

            if (inflateState.avail_in == 0 && gzipStream == null) {
                fileEnded = true;
            }

            switch (ret) {
                case ErrorStatus.Z_OK: //input data ended/ output buffer full
                    endLoop = false;
                case ErrorStatus.Z_STREAM_END: // stream ended. Note that campaign files consist from multiple such streams
                    endLoop = true;
                case ErrorStatus.Z_BUF_ERROR: // output buffer full. Can be triggered?
                    endLoop = true;
                default:
                    trace('MSG: ${inflateState.msg}');
                    if (inflateState.msg == '') {
                        throw 'Decompression error. Return code was $ret';
                    } else {
                        throw 'Decompression error: ${inflateState.msg}}';
                    }
                }
        } while (endLoop == false && inflateState.avail_out != 0);

        decompressed = inflateState.total_out - decompressed;

        // Clean up and return
        if (fileEnded)
        {
            Inflate.inflateEnd(inflateState);
            inflateState = null;
        }
        return decompressed;
    }
}
