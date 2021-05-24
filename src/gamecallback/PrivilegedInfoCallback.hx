package gamecallback;

import artifacts.Artifact;
import constants.id.PlayerColor;
import constants.SpellId;
import gamestate.GameState;
import utils.Int3.DistanceFormula;
import utils.Int3;

class PrivilegedInfoCallback extends GameInfoCallback {
    public function new() {
        super();
    }

    public function gameState():GameState {
        return _gs;
    }

    //used for random spawns
//    public function getFreeTiles (tiles:Array<Int3>) {
//
//    }

    //mode 1 - only unrevealed tiles; mode 0 - all, mode -1 -  only revealed
//    public function getTilesInRange(tiles:Map<Int3, HashInt3>, pos:Int3, radious:Int, player:PlayerColor = null, mode:Int = 0, formula:DistanceFormula = DistanceFormula.DIST_2D) {
//
//    }

    //returns all tiles on given level (-1 - both levels, otherwise number of level); surface: 0 - land and water, 1 - only land, 2 - only water
//    public function getAllTiles(tiles:Map<Int3, HashInt3>, player:PlayerColor = null, level:Int = -1, surface:Int = 0) {
//
//    }

    //gives 3 treasures, 3 minors, 1 major -> used by Black Market and Artifact Merchant
//    public function pickAllowedArtsSet(out:Array<Artifact>) {
//
//    }

//    public function getAllowedSpells(out:Array<SpellId>, level:Int) {
//
//    }
}