package gamecallback;

import netpacks.BlockingDialog;
import netpacks.TeleportDialog;
import creature.StackBasicDescriptor;
import netpacks.ShowInInfobox;
import netpacks.PackForClient;
import netpacks.SetMovePoints;
import netpacks.GiveBonus;
import netpacks.StackLocation;
import res.ResourceSet.TResources;
import constants.GameConstants.TQuantity;
import artifacts.Artifact;
import artifacts.ArtifactInstance;
import constants.ArtifactPosition;
import constants.id.ObjectInstanceId;
import constants.id.PlayerColor;
import constants.PrimarySkill;
import constants.SecondarySkill;
import constants.SpellId;
import creature.Creature;
import creature.CreatureSet;
import mapObjects.ArmedInstance;
import mapObjects.GObjectInstance;
import mapObjects.hero.GHeroInstance;
import mapObjects.town.GTownInstance;
import netpacks.ArtifactLocation;
import res.ResType;
import utils.Int3;

class GameEventCallback extends GameEventRealizer {
    public function new() {
        super();

    }
//        function changeSpells(hero:GHeroInstance, give:Bool, spells:Array<SpellId>):Void
//        {
//        }
//
//        function removeObject(obj:GObjectInstance):Bool
//        {
//        }
//
//        function setBlockVis(objid:ObjectInstanceId, bv:Bool):Void
//        {
//        }
//
//        function setOwner(objid:GObjectInstance, owner:PlayerColor):Void
//        {
//        }
//
//        function changePrimSkill(hero:GHeroInstance, which:PrimarySkill, val:Int, abs:Bool = false):Void
//        {
//        }
//
//        function changeSecSkill(hero:GHeroInstance, which:SecondarySkill, val:Int, abs:Bool = false):Void
//        {
//        }
//
//        function showBlockingDialog(iw:BlockingDialog):Void
//        {
//        }
//
//        function showGarrisonDialog(upobj:ObjectInstanceId, hid:ObjectInstanceId, removableUnits:Bool):Void  //cb will be called when player closes garrison window
//        {
//        }
//
//        function showTeleportDialog(iw:TeleportDialog):Void
//        {
//        }
//
//        function showThievesGuildWindow(player:PlayerColor, requestingObjId:ObjectInstanceId):Void
//        {
//        }
//
//        function giveResource(player:PlayerColor, which:ResType, val:Int):Void
//        {
//        }
//
//        function giveResources(player:PlayerColor, resources:TResources):Void
//        {
//        }
//
//        function giveCreatures(objid:ArmedInstance, h:GHeroInstance, creatures:CreatureSet, remove:Bool):Void
//        {
//        }
//
//        function takeCreatures(objid:ObjectInstanceId, creatures:Array<StackBasicDescriptor>):Void
//        {
//        }
//
//        function changeStackCount(sl:StackLocation, count:TQuantity, absoluteValue:Bool = false):Bool
//        {
//        }
//
//        function changeStackType(sl:StackLocation, c:Creature):Bool
//        {
//        }
//
//        function insertNewStack(sl:StackLocation, c:Creature, count:TQuantity = -1):Bool  //count -1 => moves whole stack
//        {
//        }
//
//        function eraseStack(sl:StackLocation, forceRemoval:Bool = false):Bool
//        {
//        }
//
//        function swapStacks(sl1:StackLocation, sl2:StackLocation):Bool
//        {
//        }
//
//        function addToSlot(sl:StackLocation, c:Creature, count:TQuantity):Bool  //makes new stack or increases count of already existing
//        {
//        }
//
//        function tryJoiningArmy(src:ArmedInstance, dst:ArmedInstance, removeObjWhenFinished:Bool, allowMerging:Bool):Void  //merges army from src do dst or opens a garrison window
//        {
//        }
//
//        function moveStack(src:StackLocation, dst:StackLocation, count:TQuantity):Bool
//        {
//        }
//
//        function removeAfterVisit(object:GObjectInstance):Void //object will be destroyed when Interaction is over. Do not call when Interaction is not ongoing!
//        {
//        }
//
//        function giveHeroNewArtifact(h:GHeroInstance, artType:Artifact, pos:ArtifactPosition):Void
//        {
//        }
//
//        function giveHeroArtifact(h:GHeroInstance, a:ArtifactInstance, pos:ArtifactPosition):Void //pos==-1 - first free slot in backpack pos==-2 - default if available or backpack
//        {
//        }
//
//        function putArtifact(al:ArtifactLocation, a:ArtifactInstance):Void
//        {
//        }
//
//        function removeArtifact(al:ArtifactLocation):Void
//        {
//        }
//
//        function moveArtifact(al1:ArtifactLocation, al2:ArtifactLocation):Bool
//        {
//        }
//
//        function synchronizeArtifactHandlerLists():Void
//        {
//        }
//
//        function showCompInfo(comp:ShowInInfobox):Void
//        {
//        }
//
//        function heroVisitCastle(obj:GTownInstance, hero:GHeroInstance):Void
//        {
//        }
//
//        function visitCastleObjects(obj:GTownInstance, hero:GHeroInstance):Void
//        {
//        }
//
//        function stopHeroVisitCastle(obj:GTownInstance, hero:GHeroInstance):Void
//        {
//        }
//
//        function startBattlePrimary(army1:ArmedInstance, army2:ArmedInstance, tile:Int3, hero1:GHeroInstance, hero2:GHeroInstance, creatureBank:Bool = false, town:GZTownInstance = null):Void //use hero=nullptr for no hero
//        {
//        }
//
//        function startBattleI(army1:ArmedInstance, army2:ArmedInstance, tile:Int3, creatureBank:Bool = false):Void //if any of armies is hero, hero will be used
//        {
//        }
//
//        function startBattleI(army1:ArmedInstance, army2:ArmedInstance, creatureBank:Bool = false):Void //if any of armies is hero, hero will be used, visitable tile of second obj is place of battle
//        {
//        }
//
//        function setAmount(objid:ObjectInstanceId, val:Int):Void
//        {
//        }

//        function moveHero(hid:ObjectInstanceId, dst:Int3, teleporting:Int, transit:Bool = false, asker:PlayerColor = null):Bool
//        {
//            if (asker == null) {
//                asker = PlayerColor.NEUTRAL;
//            }
//        }

//        function giveHeroBonus(bonus:GiveBonus):Void
//        {
//        }
//
//        function setMovePoInts(smp:SetMovePoints):Void
//        {
//        }
//
//        function setManaPoInts(hid:ObjectInstanceId, val:Int):Void
//        {
//        }
//
//        function giveHero(id:ObjectInstanceId, player:PlayerColor):Void
//        {
//        }
//
//        function changeObjPos(objid:ObjectInstanceId, newPos:Int3, flags:Int):Void
//        {
//        }
//
//        function sendAndApply(pack:PackForClient):Void
//        {
//        }
//
//        function heroExchange(hero1:ObjectInstanceId, hero2:ObjectInstanceId):Void //when two heroes meet on adventure map
//        {
//        }
//
//        function changeFogOfWar(center:Int3, radius:Int, player:PlayerColor, hide:Bool):Void
//        {
//        }
//
//        function changeFogOfWar(tiles:Map<Int3, HashInt3>, player:PlayerColor, hide:Bool):Void
//        {
//        }
}