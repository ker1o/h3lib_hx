package utils;

class Utils {
    public static function getColorFromBits(bitColor:Int):Int {
        // we have to invert it because of endian
        var b = (bitColor & 0x00FF0000) >> 16;
        var g = (bitColor & 0x0000FF00) >> 8;
        var r = (bitColor & 0x000000FF);
        return r << 16 | g << 8 | b;
    }

    public static function strComponents(bitColor:Int):String {
        var a = (bitColor >> 24) & 0x000000FF;
        var b = (bitColor & 0x00FF0000) >> 16;
        var g = (bitColor & 0x0000FF00) >> 8;
        var r = (bitColor & 0x000000FF);
        return '$r $g $b $a';
    }
}
