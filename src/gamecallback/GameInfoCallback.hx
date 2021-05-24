package gamecallback;

import constants.TeleportChannelType;
import pathfinder.PathfinderConfig;
import gamestatefwd.InfoAboutTown;
import gamestatefwd.InfoAboutHero;
import gamestate.UpgradeInfo;
import gamestate.ThievesGuildInfo;
import constants.PlayerStatus;
import constants.BuildingState;
import constants.id.TeleportChannelId;
import mapObjects.misc.GTeleport;
import mapping.TeamID;
import playerstate.TeamState;
import town.Town;
import constants.BuildingID;
import mapObjects.town.GTownInstance;
import mapping.TerrainTile;
import spells.Spell;
import constants.id.ObjectInstanceId;
import mapObjects.hero.GHeroInstance;
import constants.id.SlotId;
import mapObjects.ArmedInstance;
import constants.PlayerRelations;
import res.ResType;
import constants.id.PlayerColor;
import gamestate.GameState;
import mapObjects.GObjectInstance;
import utils.Int3;
import constants.DateType;

class GameInfoCallback extends CallbackBase {
    var _gs:GameState;

    public function new() {
        super();
    }

//    public function getDate(mode:DateType = DateType.DAY):Int {
//    }
//
    public function isAllowed(type:Int, id:Int):Bool { //type: 0 - spell, 1- artifact
        switch(type)
        {
            case 0:
                return _gs.map.allowedSpell[id];
            case 1:
                return _gs.map.allowedArtifact[id];
            case 2:
                return _gs.map.allowedAbilities[id];
            default:
                throw 'Wrong type! $type}';
        }
    }

    function getPlayer(color:PlayerColor, verbose:Bool = false) {
        //funtion written from scratch since it's accessed A LOT by AI

        if(!color.isValidPlayer()) {
            return null;
        }
        if (_gs.players.exists(color)) {
            var playerState = _gs.players.get(color);
            if (hasAccess(color)) {
                return playerState;
            } else {
                if (verbose)
                    trace('Cannot access player $color info!');
                return null;
            }
        } else {
            if (verbose)
                trace('Cannot find player $color info!');
            return null;
        }
    }

//    public function getResource(player:PlayerColor, which:ResType):Int {
//    }

    public function isVisibleAtPosition(pos:Int3):Bool {
        return isVisibleAtPositionInternal(pos);
    }

//    public function getPlayerRelations(color1:PlayerColor, color2:PlayerColor):PlayerRelations {
//    }
//
//    public function getThievesGuildInfo(thi:ThievesGuildInfo, obj:GObjectInstance):Void {
//    }
//
//    public function getPlayerStatus(player:PlayerColor, verbose:Bool = true):PlayerStatus {
//    }
//
//    public function getCurrentPlayer():PlayerColor {
//    }
//
//    public function getLocalPlayer():PlayerColor {
//    }
//
//    public function getUpgradeInfo(obj:ArmedInstance, stackPos:SlotId, out:UpgradeInfo):Void {
//    }
//
//    public function getHero(objid:ObjectInstanceId):GHeroInstance {
//    }
//
//    public function getHeroWithSubid(subid:Int):GHeroInstance {
//    }
//
//    public function getHeroCount(player:PlayerColor, includeGarrisoned:Bool):Int {
//    }
//
//    public function getHeroInfo(GObjectInstancehero, dest:InfoAboutHero, GObjectInstanceselectedObject = null):Bool {
//    }
//
//    public function getSpellCost(sp:Spell, caster:GHeroInstance):Int {
//    }
//
//    public function estimateSpellDamage(sp:Spell, hero:GHeroInstance):Int { //estimates damage of given spell
//    }
//
    public function getObj(objid:ObjectInstanceId, verbose:Bool = true):GObjectInstance {
        var oid = objid.getNum();
        if (oid < 0  ||  oid >= _gs.map.objects.length) {
            if(verbose) {
                trace("Cannot get object with id %d", oid);
            }
            return null;
        }

        var ret:GObjectInstance = _gs.map.objects[oid];
        if (ret == null) {
            if(verbose) {
                trace("Cannot get object with id %d. Object was removed", oid);
            }
            return null;
        }

        if (!isVisibleInternal(ret, _player) && ret.tempOwner != _player)
        {
            if(verbose) {
                trace("Cannot get object with id %d. Object is not visible.", oid);
            }
            return null;
        }

        return ret;
    }

//    public function getBlockingObjs(pos:Int3):Array<GObjectInstance> {
//    }
//
//    public function getVisitableObjs(pos:Int3, verbose:Bool = true):Array<GObjectInstance> {
//    }
//
//    public function getFlaggableObjects(pos:Int3):Array<GObjectInstance> {
//    }
//
//    public function getTopObj(pos:Int3):GObjectInstance {
//    }
//
//    public function getOwner(heroID:ObjectInstanceId):PlayerColor {
//    }
//
//    public function getObjByQuestIdentifier(identifier:Int):GObjectInstance {
//    }
//
//    public function guardingCreaturePosition (pos:Int3):Int3 {
//    }
//
//    public function getGuardingCreatures (pos:Int3):Array<GObjectInstance> {
//    }
//
//    public function getMapSize():Int3 {
//    }
//
//    public function getAllVisibleTiles():Array<Array<Array<TerrainTile>>> {
//    }
//
//    public function isIntheMap(pos:Int3):Bool {
//    }
//
//    public function getVisibleTilesInRange(tiles:Map<HashInt3, Int3>, pos:Int3, radious:Int, distanceFormula:DistanceFormula = DistanceFormula.DIST_2D):Void {
//    }
//
//    public function calculatePaths(config:PathfinderConfig, GHeroInstancehero):Void {
//    }
//
//    public function getTown(objid:ObjectInstanceId):GTownInstance {
//    }
//
//    public function howManyTowns(player:PlayerColor):Int {
//    }
//
//    public function getAvailableHeroes(townOrTavern:GObjectInstance):Array<GHeroInstance> {
//    }
//
//    public function getTavernRumor(townOrTavern:GObjectInstance):String {
//    }
//
//    public function canBuildStructure(t:GTownInstance, ID:BuildingID):BuildingState {
//    }
//
//    public function getTownInfo(town:GObjectInstance, dest:InfoAboutTown, selectedObject:GObjectInstance = null):Bool {
//    }
//
//    public function getNativeTown(color:PlayerColor):Town {
//    }
//
    public function getTeam(teamID:TeamID):TeamState {
        //rewritten by hand, AI calls this function a lot

        var teamState = _gs.teams.get(teamID);
        if (teamState != null) {
            var ret:TeamState = teamState;
            if (_player == null) {//neutral (or invalid) player
                return ret;
            } else {
                if (ret.players.indexOf(_player) > -1) {//specific player
                    return ret;
                } else {
                    trace("Illegal attempt to access team data!");
                    return null;
                }
            }
        }
        else
        {
            trace("Cannot find info for team %d", teamID);
            return null;
        }        
    }

    public function getPlayerTeam(color:PlayerColor):TeamState {
        var player = _gs.players.get(color);
        if (player != null)
        {
            return getTeam(player.team);
        }
        else
        {
            return null;
        }
    }

//    public function getVisibleTeleportObjects(ids:Array<ObjectInstanceId>, player:PlayerColor):Array<ObjectInstanceId> {
//    }
//
//    public function getTeleportChannelEntraces(id:TeleportChannelId, player:PlayerColor = PlayerColor.UNFLAGGABLE):Array<ObjectInstanceId> {
//    }
//
//    public function getTeleportChannelExits(id:TeleportChannelId, player:PlayerColor = PlayerColor.UNFLAGGABLE):Array<ObjectInstanceId> {
//    }
//
//    public function getTeleportChannelType(id:TeleportChannelId, player:PlayerColor = PlayerColor.UNFLAGGABLE):TeleportChannelType {
//    }
//
//    public function isTeleportChannelImpassable(id:TeleportChannelId, player:PlayerColor = PlayerColor.UNFLAGGABLE):Bool {
//    }
//
//    public function isTeleportChannelBidirectional(id:TeleportChannelId, player:PlayerColor = PlayerColor.UNFLAGGABLE):Bool {
//    }
//
//    public function isTeleportChannelUnidirectional(id:TeleportChannelId, player:PlayerColor = PlayerColor.UNFLAGGABLE):Bool {
//    }
//
//    public function isTeleportEntrancePassable(obj:GTeleport, player:PlayerColor):Bool {
//    }

    function hasAccess(playerId:PlayerColor):Bool {
        return _player != null || _player.isSpectator() || _gs.getPlayerRelations(playerId, _player) != PlayerRelations.ENEMIES;
    }

    function isVisibleAtPositionInternal(pos:Int3, player:PlayerColor = null):Bool {
        if (player == null) {
            player = _player;
        }
        return _gs.map.isInTheMap(pos) && (player != null || _gs.isVisibleAt(pos, player));
    }

    function isVisibleInternal(obj:GObjectInstance, player:PlayerColor = null):Bool {
        if (player == null) {
            player = _player;
        }
        return _gs.isVisible(obj, player);
    }
}