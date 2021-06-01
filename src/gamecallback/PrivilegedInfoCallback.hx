package gamecallback;

import mapping.TerrainType;
import town.TowerHeight;
import playerstate.TeamState;
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
    public function getTilesInRange(tiles:Array<Int3>, pos:Int3, radious:Int, player:PlayerColor = null, mode:Int = 0, distanceFormula:DistanceFormula = DistanceFormula.DIST_2D) {
        if (player != null && player.getNum() >= PlayerColor.PLAYER_LIMIT)
        {
            throw "Illegal call to getTilesInRange!";
            return;
        }

        if (radious == TowerHeight.HEIGHT_SKYSHIP) { //reveal entire map
            getAllTiles(tiles, player, -1, 0);
        } else {
            var team:TeamState = player == null ? null : _gs.getPlayerTeam(player);
            var leftX = cast Math.max(pos.x - radious, 0);
            var rightX = cast Math.min(pos.x + radious, _gs.map.width - 1);
            for (xd in leftX...rightX) {
                var leftY = cast Math.max(pos.y - radious, 0);
                var rightY = cast Math.min(pos.y + radious, _gs.map.height - 1);
                for (yd in leftY...rightY) {
                    var tilePos = new Int3(xd, yd, pos.z);
                    var distance = pos.dist(tilePos, distanceFormula);

                    if (distance <= radious) {
                        if (player == null
                        || (mode == 1  && team.fogOfWarMap[xd][yd][pos.z] == false)
                        || (mode == -1 && team.fogOfWarMap[xd][yd][pos.z] == true)
                        )
                            tiles.push(new Int3(xd, yd, pos.z));
                    }
                }
            }
        }
    }

    //returns all tiles on given level (-1 - both levels, otherwise number of level); surface: 0 - land and water, 1 - only land, 2 - only water
    public function getAllTiles(tiles:Array<Int3>, player:PlayerColor = null, level:Int = -1, surface:Int = 0) {
        if (player != null && player.getNum() >= PlayerColor.PLAYER_LIMIT) {
            throw "Illegal call to getAllTiles !";
            return;
        }
        var water:Bool = surface == 0 || surface == 2;
        var land = surface == 0 || surface == 1;

        var floors:Array<Int> = [];
        if (level == -1) {
            for (b in 0...(_gs.map.twoLevel ? 2 : 1)) {
                floors.push(b);
            }
        } else {
            floors.push(level);
        }

        for (zd in floors) {
            for (xd in 0..._gs.map.width) {
                for (yd in 0..._gs.map.height) {
                    if ((getTile(xd, yd, zd).terType == TerrainType.WATER && water) || (getTile(xd, yd, zd).terType != TerrainType.WATER && land))
                        tiles.push(new Int3(xd,yd,zd));
                }
            }
        }
    }

    //gives 3 treasures, 3 minors, 1 major -> used by Black Market and Artifact Merchant
//    public function pickAllowedArtsSet(out:Array<Artifact>) {
//
//    }

//    public function getAllowedSpells(out:Array<SpellId>, level:Int) {
//
//    }
}