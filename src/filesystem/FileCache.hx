package filesystem;

#if js
import haxe.Json;
import js.html.XMLHttpRequestResponseType;
import js.lib.Promise;
import utils.js.JsLoader;
#end
import filesystem.FileInputStream;
import haxe.io.Bytes;
import filesystem.ArchiveEntry;
import filesystem.CompressedStream;
import filesystem.InputStream;

using Reflect;

class FileCache {

    public static var instance(default, null) = new FileCache();

    private static var CONFIGS_ROOT_PATH = "configs";
    private static var MAPS_ROOT_PATH = "maps";
    private static var H3BIN_ROOT_PATH = "h3bin";

    private var bitmaps = new Map<String, ArchiveEntry>();
    private var fileBytes:Bytes;
    private var mapBytes:Bytes;

    private var _spriteList:Array<String>;
    private var _configs:Map<String, Dynamic>;

    private function new() {
        _configs = new Map<String, Dynamic>();
    }

#if js
    public function initGraphicsAsync():Promise<Array<String>> {
        return new Promise(function (resolve, reject) {
            if (_spriteList != null) {
                resolve(_spriteList);
            } else {
                loadBinaryByUrl(H3BIN_ROOT_PATH + "/H3sprite.lod").then(function(bytes:Bytes) {
                    fileBytes = bytes;
                    parseLod(fileBytes);
                    _spriteList = [for (key in bitmaps.keys()) key];
                    resolve(_spriteList);
                });
            }
        });
    }

    public function initMapAsync(name:String):Promise<Bool> {
        return loadBinaryByUrl(MAPS_ROOT_PATH + "/" + name).then(function(bytes:Bytes) {
            mapBytes = bytes;
            return true;
        });
    }

    public function existsSpriteResource(name:String) {
        return _spriteList.indexOf(name) > -1;
    }

    public function loadConfigs():Promise<Bool> {
        return loadConfig('config.json').then(function(success:Bool) {
            return loadConfig('h3mconfig.json');
        }).then(function(success:Bool) {
            return loadConfig('modData.json');
        });
    }

    public function loadConfig(url:String):Promise<Bool> {
        return loadTextByUrl(CONFIGS_ROOT_PATH + "/" + url).then(function(json:String) {
            try {
                _configs[url] = Json.parse(json);
            }
            catch(e:Dynamic) {
                trace('Url "$url" wasnt loaded.');
                throw e;
            }
            return true;
        });
    }

    public function getConfig(configName:String):Dynamic {
        var configBase:String = configName.split("/")[0].toLowerCase();
        return switch (configBase) {
            case "config": _configs["config.json"].field(configName);
            case "data": _configs["h3mconfig.json"].field(configName);
            case "mod": _configs['modData.json'];
            case _: null;
        }
    }

#else
    public function initGraphics() {
        // use it for local checks in neko
        fileBytes = loadBinary(H3BIN_ROOT_PATH + "/H3sprite.lod");
        parseLod(fileBytes);
    }

    public function initMap(name:String) {
        mapBytes = loadBinary(name);
    }
#end

    public function getMap(name:String):Bytes {
        return mapBytes;
    }

    public function getCahedFile(name:String):Bytes {
        var data = getInputStream(name).readAll();
        return data.data;
    }

#if js
    private function loadBinaryByUrl(url:String):Promise<Bytes> {
        return new JsLoader(url).load().then(function(bytes:Bytes) {
            return bytes;
        });
    }

    private function loadTextByUrl(url:String):Promise<String> {
        return new JsLoader(url, XMLHttpRequestResponseType.TEXT).load().then(function(text:String) {
            return text;
        });
    }

#else
    private function loadBinary(url:String):Bytes {
        trace('load $url, exists: ${sys.FileSystem.exists(url)}');
        if(!sys.FileSystem.exists(url)) return null;
        return sys.io.File.getBytes(url);
    }
#end

    private function parseLod(bytes:Bytes) {
        var pos:Int = 8;
        trace('bytes length: ${bytes.length}, ${bytes == null}');
        var totalFiles = bytes.getInt32(pos);
        trace('Total files: $totalFiles');

        pos = 0x5C;
        for(i in 0...totalFiles) {
            var archiveEntry = new ArchiveEntry();
            var name = bytes.getString(pos, 16); pos += 16;
            var index = name.indexOf(String.fromCharCode(0));
            if(index > 0) {
                name = name.substring(0, index);
            }
            archiveEntry.name = name.toLowerCase();
            archiveEntry.offset = bytes.getInt32(pos); pos += 4;
            archiveEntry.fullSize = bytes.getInt32(pos); pos += 4;
            pos += 4;
            archiveEntry.compressedSize = bytes.getInt32(pos); pos += 4;

//            trace(archiveEntry);
            bitmaps.set(archiveEntry.name, archiveEntry);
        }
    }

    private function getInputStream(name:String):InputStream {
        // fix key
        var keyName = name.toLowerCase();
        if (keyName.indexOf(".") == -1) {
            keyName += ".def";
        }

        var entry:ArchiveEntry = bitmaps.get(keyName);
        if(entry == null) throw '$name resource is not found';

        if (entry.compressedSize != 0) {
            var filestream = new FileInputStream(fileBytes, entry.offset, entry.compressedSize);
            return new CompressedStream(filestream, false, entry.fullSize);
        } else {
            return new FileInputStream(fileBytes, entry.offset, entry.fullSize);
        }
    }


}
