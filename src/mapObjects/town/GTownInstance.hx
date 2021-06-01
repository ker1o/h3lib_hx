package mapObjects.town;

import mapObjects.GObjectInstance;
import playerstate.PlayerState;
import mapObjects.misc.GShipyard;
import res.ResourceSet.TResources;
import mapping.MapBody;
import constants.Obj;
import mapping.CastleEvent;
import town.Town;
import artifacts.Artifact;
import mapObjects.hero.GHeroInstance;
import constants.SpellId;
import constants.BuildingID;

using Lambda;

class GTownInstance extends GDwelling implements IShipyard {
    public var townAndVis:TownAndVisitingHero;
    public var town:Town;
    public var name:String; // name of town
    public var builded:Int = 0; //how many buildings has been built this turn
    public var destroyed:Int = 0; //how many buildings has been destroyed this turn
    public var garrisonHero:GHeroInstance;
    public var visitingHero:GHeroInstance;
    public var identifier:Int = 0; //special identifier from h3m (only > RoE maps)
    public var alignment:Int = 255;
    public var forbiddenBuildings:Array<BuildingID> = [];
    public var builtBuildings:Array<BuildingID> = [];
    public var bonusingBuildings:Array<GTownBuilding> = [];
    public var possibleSpells:Array<SpellId> = [];
    public var obligatorySpells:Array<SpellId> = [];
    public var spells:Array<Array<SpellId>> = []; //spells[level] -> vector of spells, first will be available in guild
    public var events:Array<CastleEvent> = [];
    public var bonusValue:{town:Int, bonuses:Int};//var to store town bonuses (rampart = resources from mystic pond);

    //////////////////////////////////////////////////////////////////////////
    static public var merchantArtifacts:Array<Artifact> = []; //vector of artifacts available at Artifact merchant, NULLs possible (for making empty space when artifact is bought)
    static public var universitySkills:Array<Int> = [];//skills for university of magic

    private var _shipyard:GShipyard;
    
    public function new() {
        super();

        _shipyard = new GShipyard(this);

        townAndVis = new TownAndVisitingHero();
    }

    override public function afterAddToMap(map:MapBody) {
        if(ID == Obj.TOWN) {
            map.towns.push(this);
        }
    }

    public function getUpperArmy():ArmedInstance {
        if (garrisonHero != null) {
            return garrisonHero;
        }
        return this;
    }

    public function dailyIncome() {
        var ret:TResources = new TResources();

        for (buildingId1 in town.buildings.keys()) {
            var building1 = town.buildings[buildingId1];
            var buildingUpgrade:BuildingID = BuildingID.NONE;

            for (buildingId2 in town.buildings.keys()) {
                var building2 = town.buildings[buildingId2];
                if (building2.upgrade == buildingId1) {
                    buildingUpgrade = buildingId2;
                }
            }

            if (!hasBuilt(buildingUpgrade) && hasBuilt(buildingId1)) {
                ret.add(building1.produce);
            }
        }

        return ret;
    }

    public function hasBuilt(buildingID:BuildingID) {
        return builtBuildings.contains(buildingID);
    }

    public function hallLevel():Int { // -1 - none, 0 - village, 1 - town, 2 - city, 3 - capitol
        if (hasBuilt(BuildingID.CAPITOL))
            return 3;
        if (hasBuilt(BuildingID.CITY_HALL))
            return 2;
        if (hasBuilt(BuildingID.TOWN_HALL))
            return 1;
        if (hasBuilt(BuildingID.VILLAGE_HALL))
            return 0;
        return -1;
    }

    public function fortLevel():FortLevel { //0 - none, 1 - fort, 2 - citadel, 3 - castle
        if (hasBuilt(BuildingID.CASTLE))
            return FortLevel.CASTLE;
        if (hasBuilt(BuildingID.CITADEL))
            return FortLevel.CITADEL;
        if (hasBuilt(BuildingID.FORT))
            return FortLevel.FORT;
        return FortLevel.NONE;
    }

    public function shipyardStatus() {
        return _shipyard.shipyardStatus();
    }

    public function getBoatCost() {
        return _shipyard.getBoatCost();
    }

    public function deserializationFix() {
        bonusSystemNode.attachTo(townAndVis);
    }

    public function setVisitingHero(h:GHeroInstance) {
        if (h != null) {
            var p:PlayerState = GObjectInstance.cb.gameState().getPlayer(h.tempOwner);
//            assert(p);
            h.bonusSystemNode.detachFrom(p);
            h.bonusSystemNode.attachTo(townAndVis);
            visitingHero = h;
            h.visitedTown = this;
            h.inTownGarrison = false;
        } else {
            var p:PlayerState = GObjectInstance.cb.gameState().getPlayer(visitingHero.tempOwner);
            visitingHero.visitedTown = null;
            visitingHero.bonusSystemNode.detachFrom(townAndVis);
            visitingHero.bonusSystemNode.attachTo(p);
            visitingHero = null;
        }
    }
}
