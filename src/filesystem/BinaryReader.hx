package filesystem;

import haxe.io.Bytes;

class BinaryReader {

    private static var win1251 = [
        128 => 'Ђ',
        129 => 'Ѓ',
        130 => '‚',
        131 => 'ѓ',
        132 => '„',
        133 => '…',
        134 => '†',
        135 => '‡',
        136 => '€',
        137 => '‰',
        138 => 'Љ',
        139 => '‹',
        140 => 'Њ',
        141 => 'Ќ',
        142 => 'Ћ',
        143 => 'Џ',
        144 => 'ђ',
        145 => '‘',
        146 => '’',
        147 => '“',
        148 => '”',
        149 => '•',
        150 => '–',
        151 => '—',
        152 => '',
        153 => '™',
        154 => 'љ',
        155 => '›',
        156 => 'њ',
        157 => 'ќ',
        158 => 'ћ',
        159 => 'џ',
        160 => ' ',
        161 => 'Ў',
        162 => 'ў',
        163 => 'Ј',
        164 => '¤',
        165 => 'Ґ',
        166 => '¦',
        167 => '§',
        168 => 'Ё',
        169 => '©',
        170 => 'Є',
        171 => '«',
        172 => '¬',
        173 => '­',
        174 => '®',
        175 => 'Ї',
        176 => '°',
        177 => '±',
        178 => 'І',
        179 => 'і',
        180 => 'ґ',
        181 => 'µ',
        182 => '¶',
        183 => '·',
        184 => 'ё',
        185 => '№',
        186 => 'є',
        187 => '»',
        188 => 'ј',
        189 => 'Ѕ',
        190 => 'ѕ',
        191 => 'ї',
        192 => 'А',
        193 => 'Б',
        194 => 'В',
        195 => 'Г',
        196 => 'Д',
        197 => 'Е',
        198 => 'Ж',
        199 => 'З',
        200 => 'И',
        201 => 'Й',
        202 => 'К',
        203 => 'Л',
        204 => 'М',
        205 => 'Н',
        206 => 'О',
        207 => 'П',
        208 => 'Р',
        209 => 'С',
        210 => 'Т',
        211 => 'У',
        212 => 'Ф',
        213 => 'Х',
        214 => 'Ц',
        215 => 'Ч',
        216 => 'Ш',
        217 => 'Щ',
        218 => 'Ъ',
        219 => 'Ы',
        220 => 'Ь',
        221 => 'Э',
        222 => 'Ю',
        223 => 'Я',
        224 => 'а',
        225 => 'б',
        226 => 'в',
        227 => 'г',
        228 => 'д',
        229 => 'е',
        230 => 'ж',
        231 => 'з',
        232 => 'и',
        233 => 'й',
        234 => 'к',
        235 => 'л',
        236 => 'м',
        237 => 'н',
        238 => 'о',
        239 => 'п',
        240 => 'р',
        241 => 'с',
        242 => 'т',
        243 => 'у',
        244 => 'ф',
        245 => 'х',
        246 => 'ц',
        247 => 'ч',
        248 => 'ш',
        249 => 'щ',
        250 => 'ъ',
        251 => 'ы',
        252 => 'ь',
        253 => 'э',
        254 => 'ю',
        255 => 'я',
    ];

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
        var str = getString(bytes, pos, len);
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

    private function getString(bytes:Bytes, pos:Int, len:Int):String {
        var s = "";
        for (i in 0...len) {
            var charCode:Int = bytes.get(pos + i);
            if (charCode < 0x80) {
                s += String.fromCharCode(charCode);
            } else {
                s += win1251[charCode];
            }
        }
        return s;
    }
}
