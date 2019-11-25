package lib.mod;

import lib.artifacts.ArtHandler;
import lib.creature.CreatureHandler;
import lib.hero.HeroHandler;
import lib.mapObjects.ObjectClassesHandler;
import lib.mapObjects.ObjectsHandler;
import lib.mapping.TerrainViewPatternConfig;
import lib.skill.SkillHandler;
import lib.spells.SpellHandler;
import lib.text.GeneralTextHandler;
import lib.town.TownHandler;

class LibClasses {
    public var heroh:HeroHandler;
    public var arth:ArtHandler;
    public var creh:CreatureHandler;
    public var spellh:SpellHandler;
    public var skillh:SkillHandler;
    public var objh:ObjectsHandler;
    public var objtypeh:ObjectClassesHandler;
    public var townh:TownHandler;
    public var generaltexth:GeneralTextHandler;
    public var modh:ModHandler;
    public var terviewh:TerrainViewPatternConfig;
//    public var tplh:RmgTemplateStorage;

    public function new() {
    }

    private function instantiateHandlers() {
        heroh = new HeroHandler();
        arth = new ArtHandler();
        creh = new CreatureHandler();
        spellh = new SpellHandler();
        skillh = new SkillHandler();
        objh = new ObjectsHandler();
        objtypeh = new ObjectClassesHandler();
        townh = new TownHandler();
        generaltexth = new GeneralTextHandler();
        modh = new ModHandler();
        terviewh = new TerrainViewPatternConfig();
//        tplh = new RmgTemplateStorage();
    }

    public function loadFilesystem() {
        modh = new ModHandler();
        instantiateHandlers();
    }

    public function init() {
        modh.load();
    }
}
