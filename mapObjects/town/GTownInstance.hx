package lib.mapObjects.town;

import mapping.MapBody;
import constants.Obj;
import lib.mapping.CastleEvent;
import lib.town.Town;
import lib.artifacts.Artifact;
import lib.mapObjects.hero.GHeroInstance;
import constants.SpellId;
import constants.BuildingID;

class GTownInstance extends GDwelling {
    public var townAndVis:TownAndVisitingHero;
    public var town:Town;
    public var name:String; // name of town
    public var builded:Int; //how many buildings has been built this turn
    public var destroyed:Int; //how many buildings has been destroyed this turn
    public var garrisonHero:GHeroInstance;
    public var visitingHero:GHeroInstance;
    public var identifier:Int; //special identifier from h3m (only > RoE maps)
    public var alignment:Int;
    public var forbiddenBuildings:Array<BuildingID>;
    public var builtBuildings:Array<BuildingID>;
    public var bonusingBuildings:Array<GTownBuilding>;
    public var possibleSpells:Array<SpellId>;
    public var obligatorySpells:Array<SpellId>;
    public var spells:Array<Array<SpellId>>; //spells[level] -> vector of spells, first will be available in guild
    public var events:Array<CastleEvent>;
    public var bonusValue:{town:Int, bonuses:Int};//var to store town bonuses (rampart = resources from mystic pond);

    //////////////////////////////////////////////////////////////////////////
    static public var merchantArtifacts:Array<Artifact>; //vector of artifacts available at Artifact merchant, NULLs possible (for making empty space when artifact is bought)
    static public var universitySkills:Array<Int>;//skills for university of magic
    
    public function new() {
        super();

        forbiddenBuildings = [];
        builtBuildings = [];
        bonusingBuildings = [];
        possibleSpells = [];
        obligatorySpells = [];
        spells = [];
        events = [];
    }

    override public function afterAddToMap(map:MapBody) {
        if(ID == Obj.TOWN) {
            map.towns.push(this);
        }
    }

}
