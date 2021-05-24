package mapObjects;

import filesystem.FileCache;
import Reflect;

class ObjectHandler {
    public var resVals:Array<Int>; //default values of resources in gold

    public function new() {
        var data:Dynamic = FileCache.instance.getConfig("config/resources.json");
        var config:Array<Int> = cast Reflect.field(data, "resources_prices");
        resVals = [for(price in config) price];
    }
}
