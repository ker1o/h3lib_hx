package lib.constants;

import lib.mod.VLC;
import lib.artifacts.Artifact;

@:enum abstract ArtifactId(Int) from Int to Int {
    public var NONE:Int = -1;
    public var SPELLBOOK:Int = 0;
    public var SPELL_SCROLL:Int = 1;
    public var GRAIL:Int = 2;
    public var CATAPULT:Int = 3;
    public var BALLISTA:Int = 4;
    public var AMMO_CART:Int = 5;
    public var FIRST_AID_TENT:Int = 6;
    public var CENTAUR_AXE:Int = 7;
    public var BLACKSHARD_OF_THE_DEAD_KNIGHT:Int = 8;
    public var ARMAGEDDONS_BLADE:Int = 128;
    public var TITANS_THUNDER:Int = 135;
    public var CORNUCOPIA:Int = 140;
    //FIXME: the following is only true if WoG is enabled. Otherwise other mod artifacts will take these slots.
    public var ART_SELECTION:Int = 144;
    public var ART_LOCK:Int = 145; // FIXME: We must get rid of this one since it's conflict with artifact from mods. See issue 2455
    public var AXE_OF_SMASHING:Int = 146;
    public var MITHRIL_MAIL:Int = 147;
    public var SWORD_OF_SHARPNESS:Int = 148;
    public var HELM_OF_IMMORTALITY:Int = 149;
    public var PENDANT_OF_SORCERY:Int = 150;
    public var BOOTS_OF_HASTE:Int = 151;
    public var BOW_OF_SEEKING:Int = 152;
    public var DRAGON_EYE_RING:Int = 153;
    public var HARDENED_SHIELD:Int = 154;
    //public var SLAVAS_RING_OF_POWER:Int = 155;

    public inline function toArtifact():Artifact {
        return VLC.instance.arth.artifacts[this];
    }
}
