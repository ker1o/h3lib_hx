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

    public static function shuffleArray<T>(arr:Array<T>) {
        var i = arr.length - 1;
        while (i > 0) {
            var j = Math.floor(Math.random() * (i + 1));
            swap(arr, i , j);
            i--;
        }
    }

    public static function swap<T>(data:Array<T>, p1:Int, p2:Int) {
        var temp:T = data[p1];
        data[p1] = data[p2];
        data[p2] = temp;
    }
}
