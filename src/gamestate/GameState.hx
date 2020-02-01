package gamestate;

import mapping.IMapService;
import mapping.MapBody;
import startinfo.StartInfo;

class GameState {
    public var map:MapBody;

    public function new() {

    }

    public function init(mapService:IMapService, startInfo:StartInfo = null, allowSavingRandomMap:Bool = false) {
        //ToDo
        initNewGame(mapService, "Vial of Life.h3m");
    }

    private function initNewGame(mapService:IMapService, mapName:String) {
        mapService.loadMapHeaderByName(mapName);
        map = mapService.loadMapByName(mapName);
    }
}