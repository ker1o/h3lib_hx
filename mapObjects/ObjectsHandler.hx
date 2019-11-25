package lib.mapObjects;

import haxe.Json;
import Reflect;
import data.ConfigData;
import lib.mod.IHandlerBase;

class ObjectsHandler {
    public var resVals:Array<Int>; //default values of resources in gold

    public function new() {
        var data:Dynamic = Json.parse(ConfigData.data.get("config/resources.json"));
        var config:Array<Int> = cast Reflect.field(data, "resources_prices");
        resVals = [for(price in config) price];
    }
}
