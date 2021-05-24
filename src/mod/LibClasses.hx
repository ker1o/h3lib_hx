package mod;

import artifacts.ArtHandler;
import creature.CreatureHandler;
import hero.HeroHandler;
import mapObjects.ObjectClassesHandler;
import mapObjects.ObjectHandler;
import mapping.TerrainViewPatternConfig;
import skill.SkillHandler;
import spells.SpellHandler;
import text.GeneralTextHandler;
import town.TownHandler;

class LibClasses {
    public var heroh:HeroHandler;
    public var arth:ArtHandler;
    public var creh:CreatureHandler;
    public var spellh:SpellHandler;
    public var skillh:SkillHandler;
    public var objh:ObjectHandler;
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
        objh = new ObjectHandler();
        objtypeh = new ObjectClassesHandler();
        townh = new TownHandler();
        generaltexth = new GeneralTextHandler();
        terviewh = new TerrainViewPatternConfig();
//        tplh = new RmgTemplateStorage();
    }

    public function loadFilesystem() {
        modh = new ModHandler();
        modh.loadMods();
        instantiateHandlers();
    }

    public function init() {
        modh.load();
    }
}
