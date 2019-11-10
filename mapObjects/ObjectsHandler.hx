package lib.mapObjects;

import Reflect;
import data.ConfigData;
import lib.mod.IHandlerBase;

class ObjectsHandler implements IHandlerBase {
    public var resVals:Array<Int>; //default values of resources in gold

    public function new() {
        resVals = [];

        var config:Array<Int> = cast Reflect.field(ConfigData.data.get("config/resources.json"), "resources_prices");
        resVals = [for(price in config) price];
    }

    public function loadLegacyData(dataSize:Int):Array<Dynamic> {


    }
}
