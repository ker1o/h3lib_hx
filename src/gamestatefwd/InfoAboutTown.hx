package gamestatefwd;

import constants.BuildingID;
import res.ResType;
import res.ResourceSet.TResources;
import mapObjects.town.GTownInstance;
import town.Town;

class InfoAboutTown extends InfoAboutArmy {
    public var details:TownDetails;
    public var tType:Town;

    public var built:Int = 0;
    public var fortLevel:Int = 0; //0 - none

    public function new(t:GTownInstance = null, detailed:Bool = false) {
        super();
        if (t != null) {
            initFromTown(t, detailed);
        }
    }

    public function initFromTown(t:GTownInstance, detailed:Bool) {
        initFromArmy(t, detailed);
        army = new ArmyDescriptor(t.getUpperArmy(), detailed);
        built = t.builded;
        fortLevel = t.fortLevel();
        name = t.name;
        tType = t.town;

        details = null;
        
        if (detailed) {
            //include details about hero
            details = new TownDetails();
            var income:TResources = t.dailyIncome();
            details.goldIncome = income[ResType.GOLD];
            details.customRes = t.hasBuilt(BuildingID.RESOURCE_SILO);
            details.hallLevel = t.hallLevel();
            details.garrisonedHero = t.garrisonHero != null;
        }
    }
}

class TownDetails {
    public var hallLevel:Int;
    public var goldIncome:Int;
    public var customRes:Bool;
    public var garrisonedHero:Bool;

    public function new() {

    }
}