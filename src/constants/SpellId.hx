package constants;

import spells.Spell;
import mod.VLC;
@:enum abstract SpellId(Int) from Int to Int{
    public var PRESET:Int = -2;
    public var NONE:Int = -1;
    public var SUMMON_BOAT:Int = 0;
    public var SCUTTLE_BOAT:Int = 1;
    public var VISIONS:Int = 2;
    public var VIEW_EARTH:Int = 3;
    public var DISGUISE:Int = 4;
    public var VIEW_AIR:Int = 5;
    public var FLY:Int = 6;
    public var WATER_WALK:Int = 7;
    public var DIMENSION_DOOR:Int = 8;
    public var TOWN_PORTAL:Int = 9;
    public var QUICKSAND:Int = 10;
    public var LAND_MINE:Int = 11;
    public var FORCE_FIELD:Int = 12;
    public var FIRE_WALL:Int = 13;
    public var EARTHQUAKE:Int = 14;
    public var MAGIC_ARROW:Int = 15;
    public var ICE_BOLT:Int = 16;
    public var LIGHTNING_BOLT:Int = 17;
    public var IMPLOSION:Int = 18;
    public var CHAIN_LIGHTNING:Int = 19;
    public var FROST_RING:Int = 20;
    public var FIREBALL:Int = 21;
    public var INFERNO:Int = 22;
    public var METEOR_SHOWER:Int = 23;
    public var DEATH_RIPPLE:Int = 24;
    public var DESTROY_UNDEAD:Int = 25;
    public var ARMAGEDDON:Int = 26;
    public var SHIELD:Int = 27;
    public var AIR_SHIELD:Int = 28;
    public var FIRE_SHIELD:Int = 29;
    public var PROTECTION_FROM_AIR:Int = 30;
    public var PROTECTION_FROM_FIRE:Int = 31;
    public var PROTECTION_FROM_WATER:Int = 32;
    public var PROTECTION_FROM_EARTH:Int = 33;
    public var ANTI_MAGIC:Int = 34;
    public var DISPEL:Int = 35;
    public var MAGIC_MIRROR:Int = 36;
    public var CURE:Int = 37;
    public var RESURRECTION:Int = 38;
    public var ANIMATE_DEAD:Int = 39;
    public var SACRIFICE:Int = 40;
    public var BLESS:Int = 41;
    public var CURSE:Int = 42;
    public var BLOODLUST:Int = 43;
    public var PRECISION:Int = 44;
    public var WEAKNESS:Int = 45;
    public var STONE_SKIN:Int = 46;
    public var DISRUPTING_RAY:Int = 47;
    public var PRAYER:Int = 48;
    public var MIRTH:Int = 49;
    public var SORROW:Int = 50;
    public var FORTUNE:Int = 51;
    public var MISFORTUNE:Int = 52;
    public var HASTE:Int = 53;
    public var SLOW:Int = 54;
    public var SLAYER:Int = 55;
    public var FRENZY:Int = 56;
    public var TITANS_LIGHTNING_BOLT:Int = 57;
    public var COUNTERSTRIKE:Int = 58;
    public var BERSERK:Int = 59;
    public var HYPNOTIZE:Int = 60;
    public var FORGETFULNESS:Int = 61;
    public var BLIND:Int = 62;
    public var TELEPORT:Int = 63;
    public var REMOVE_OBSTACLE:Int = 64;
    public var CLONE:Int = 65;
    public var SUMMON_FIRE_ELEMENTAL:Int = 66;
    public var SUMMON_EARTH_ELEMENTAL:Int = 67;
    public var SUMMON_WATER_ELEMENTAL:Int = 68;
    public var SUMMON_AIR_ELEMENTAL:Int = 69;
    public var STONE_GAZE:Int = 70;
    public var POISON:Int = 71;
    public var BIND:Int = 72;
    public var DISEASE:Int = 73;
    public var PARALYZE:Int = 74;
    public var AGE:Int = 75;
    public var DEATH_CLOUD:Int = 76;
    public var THUNDERBOLT:Int = 77;
    public var DISPEL_HELPFUL_SPELLS:Int = 78;
    public var DEATH_STARE:Int = 79;
    public var ACID_BREATH_DEFENSE:Int = 80;
    public var ACID_BREATH_DAMAGE:Int = 81;
    public var FIRST_NON_SPELL:Int = 70;
    public var AFTER_LAST:Int = 82;

    public function toSpell():Spell {
        return VLC.instance.spellh.objects[this];
    }
}
