package lib.filesystem;

import lib.filesystem.BytesUtil;
import lib.utils.Utils;
import haxe.io.UInt8Array;
import haxe.io.Bytes;

class BufferedStream extends InputStream {

    private var position:Int;
    private var buffer:UInt8Array;
    private var endOfFileReached:Bool;

    private var currentLength:Int;
    private var noDecompressedSize:Bool; // true if we don't know the final bytes size and increase the buffer size dynamically

    public function new(decompressedSize = 0) {
        super();
        position = 0;
        buffer = new UInt8Array(decompressedSize);
        noDecompressedSize = decompressedSize == 0;
        endOfFileReached = false;
        currentLength = 0;
    }

    public function tell():Int {
        return position;
    }

    public function ensureSize(size:Int) {
        while (currentLength < size && !endOfFileReached) {
            var initialSize = currentLength;
            var currentStep = size < currentLength ? size : currentLength;
            currentStep = currentStep > 1024 ? currentStep : 1024;

            var stepBuffer = Bytes.alloc(currentStep);

            currentLength = initialSize + currentStep;
            if (noDecompressedSize) {
                buffer = UInt8Array.fromBytes(BytesUtil.resize(buffer.view.buffer, currentLength));
            }
            var readSize = readMore(buffer, currentStep);

            if (readSize != currentStep) {
                endOfFileReached = true;
                currentLength = initialSize + readSize;
                if (noDecompressedSize) {
                    buffer = UInt8Array.fromBytes(BytesUtil.resize(buffer.view.buffer, currentLength));
                }
                return;
            }
        }
    }

    public function readMore(data:UInt8Array, size:Int):Int {
        throw "[ERROR] BufferedStream.readMore() is abstract!";
    }

    override public function getSize():Int {
        var previousPos = tell();
        seek(2147483647);
        var size = tell();
        seek(previousPos);
        return size;
    }

    override public function seek(position:Int):Int {
        ensureSize(position);
        this.position = position < currentLength ? position : currentLength;
        return this.position;
    }

    override public function read(data:Bytes, size:Int):Int {
        ensureSize(position + size);

        var start = position;
        var toRead = Std.int(Math.min(size, currentLength - position));
        data.blit(0, buffer.view.buffer, start, toRead);

//        trace(data.getData().bytes.toHex());
        position += toRead;
        return size;
    }

}
