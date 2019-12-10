package lib.herobonus;

@:enum abstract BonusType(Int) from Int to Int {
    public var UNDEFINED:Int = -1;
    public var NONE:Int = 0; //
    public var LEVEL_COUNTER:Int = 1; //for commander artifacts*/
    public var MOVEMENT:Int = 2; //both water/land*/
    public var LAND_MOVEMENT:Int = 3; //
    public var SEA_MOVEMENT:Int = 4; //
    public var MORALE:Int = 5; //
    public var LUCK:Int = 6; //
    public var PRIMARY_SKILL:Int = 7; //uses subtype to pick skill; additional info if set: 1 - only melee, 2 - only distance*/
    public var SIGHT_RADIOUS:Int = 8; //the correct word is RADIUS, but this one's already used in mods */
    public var MANA_REGENERATION:Int = 9; //points per turn apart from normal (1 + mysticism)*/
    public var FULL_MANA_REGENERATION:Int = 10; //all mana points are replenished every day*/
    public var NONEVIL_ALIGNMENT_MIX:Int = 11; //good and neutral creatures can be mixed without morale penalty*/
    public var SECONDARY_SKILL_PREMY:Int = 12; //%*/
    public var SURRENDER_DISCOUNT:Int = 13; //%*/
    public var STACKS_SPEED:Int = 14; //additional info - percent of speed bonus applied after direct bonuses; >0 - added, <0 - subtracted to this part*/
    public var FLYING_MOVEMENT:Int = 15; //value - penalty percentage*/
    public var SPELL_DURATION:Int = 16; //
    public var AIR_SPELL_DMG_PREMY:Int = 17; //
    public var EARTH_SPELL_DMG_PREMY:Int = 18; //
    public var FIRE_SPELL_DMG_PREMY:Int = 19; //
    public var WATER_SPELL_DMG_PREMY:Int = 20; //
    public var WATER_WALKING:Int = 21; //value - penalty percentage*/
    public var NEGATE_ALL_NATURAL_IMMUNITIES:Int = 22; //
    public var STACK_HEALTH:Int = 23; //
    public var BLOCK_MORALE:Int = 24; //
    public var BLOCK_LUCK:Int = 25; //
    public var FIRE_SPELLS:Int = 26; //
    public var AIR_SPELLS:Int = 27; //
    public var WATER_SPELLS:Int = 28; //
    public var EARTH_SPELLS:Int = 29; //
    public var GENERATE_RESOURCE:Int = 30; //daily value, uses subtype (resource type)*/
    public var CREATURE_GROWTH:Int = 31; //for legion artifacts: value - week growth bonus, subtype - monster level if aplicable*/
    public var WHIRLPOOL_PROTECTION:Int = 32; //hero won't lose army when teleporting through whirlpool*/
    public var SPELL:Int = 33; //hero knows spell, val - skill level (0 - 3), subtype - spell id*/
    public var SPELLS_OF_LEVEL:Int = 34; //hero knows all spells of given level, val - skill level; subtype - level*/
    public var BATTLE_NO_FLEEING:Int = 35; //for shackles of war*/
    public var MAGIC_SCHOOL_SKILL:Int = 36; //eg. for magic plains terrain, subtype: school of magic (0 - all, 1 - fire, 2 - air, 4 - water, 8 - earth), value - level*/
    public var FREE_SHOOTING:Int = 37; //stacks can shoot even if otherwise blocked (sharpshooter's bow effect)*/
    public var OPENING_BATTLE_SPELL:Int = 38; //casts a spell at expert level at beginning of battle, val - spell power, subtype - spell id*/
    public var IMPROVED_NECROMANCY:Int = 39; //raise more powerful creatures: subtype - creature type raised, addInfo - [required necromancy level, required stack level] */
    public var CREATURE_GROWTH_PERCENT:Int = 40; //increases growth of all units in all towns, val - percentage*/
    public var FREE_SHIP_BOARDING:Int = 41; //movement points preserved with ship boarding and landing*/
    public var NO_TYPE:Int = 42; //
    public var FLYING:Int = 43; //
    public var SHOOTER:Int = 44; //
    public var CHARGE_IMMUNITY:Int = 45; //
    public var ADDITIONAL_ATTACK:Int = 46; //
    public var UNLIMITED_RETALIATIONS:Int = 47; //
    public var NO_MELEE_PENALTY:Int = 48; //
    public var JOUSTING:Int = 49; //for champions*/
    public var HATE:Int = 50; //eg. angels hate devils, subtype - ID of hated creature, val - damage bonus percent */
    public var KING1:Int = 51; //
    public var KING2:Int = 52; //
    public var KING3:Int = 53; //
    public var MAGIC_RESISTANCE:Int = 54; //in % (value)*/
    public var CHANGES_SPELL_COST_FOR_ALLY:Int = 55; //in mana points (value) , eg. mage*/
    public var CHANGES_SPELL_COST_FOR_ENEMY:Int = 56; //in mana points (value) , eg. pegasus */
    public var SPELL_AFTER_ATTACK:Int = 57; //subtype - spell id, value - chance %, addInfo[0] - level, addInfo[1] -> [0 - all attacks, 1 - shot only, 2 - melee only] */
    public var SPELL_BEFORE_ATTACK:Int = 58; //subtype - spell id, value - chance %, addInfo[0] - level, addInfo[1] -> [0 - all attacks, 1 - shot only, 2 - melee only] */
    public var SPELL_RESISTANCE_AURA:Int = 59; //eg. unicorns, value - resistance bonus in % for adjacent creatures*/
    public var LEVEL_SPELL_IMMUNITY:Int = 60; //creature is immune to all spell with level below or equal to value of this bonus */
    public var BLOCK_MAGIC_ABOVE:Int = 61; //blocks casting spells of the level > value */
    public var BLOCK_ALL_MAGIC:Int = 62; //blocks casting spells*/
    public var TWO_HEX_ATTACK_BREATH:Int = 63; //eg. dragons*/
    public var SPELL_DAMAGE_REDUCTION:Int = 64; //eg. golems; value - reduction in %, subtype - spell school; -1 - all, 0 - air, 1 - fire, 2 - water, 3 - earth*/
    public var NO_WALL_PENALTY:Int = 65; //
    public var NON_LIVING:Int = 66; //eg. gargoyle*/
    public var RANDOM_SPELLCASTER:Int = 67; //eg. master genie, val - level*/
    public var BLOCKS_RETALIATION:Int = 68; //eg. naga*/
    public var SPELL_IMMUNITY:Int = 69; //subid - spell id*/
    public var MANA_CHANNELING:Int = 70; //value in %, eg. familiar*/
    public var SPELL_LIKE_ATTACK:Int = 71; //subtype - spell, value - spell level; range is taken from spell, but damage from creature; eg. magog*/
    public var THREE_HEADED_ATTACK:Int = 72; //eg. cerberus*/
    public var DAEMON_SUMMONING:Int = 73; //pit lord, subtype - type of creatures, val - hp per unit*/
    public var FIRE_IMMUNITY:Int = 74; //subtype 0 - all, 1 - all except positive, 2 - only damage spells*/
    public var WATER_IMMUNITY:Int = 75; //
    public var EARTH_IMMUNITY:Int = 76; //
    public var AIR_IMMUNITY:Int = 77; //
    public var MIND_IMMUNITY:Int = 78; //
    public var FIRE_SHIELD:Int = 79; //
    public var UNDEAD:Int = 80; //
    public var HP_REGENERATION:Int = 81; //creature regenerates val HP every new round*/
    public var FULL_HP_REGENERATION:Int = 82; //first creature regenerates all HP every new round; subtype 0 - animation 4 (trolllike), 1 - animation 47 (wightlike)*/
    public var MANA_DRAIN:Int = 83; //value - spell points per turn*/
    public var LIFE_DRAIN:Int = 84; //
    public var DOUBLE_DAMAGE_CHANCE:Int = 85; //value in %, eg. dread knight*/
    public var RETURN_AFTER_STRIKE:Int = 86; //
    public var SELF_MORALE:Int = 87; //eg. minotaur*/
    public var SPELLCASTER:Int = 88; //subtype - spell id, value - level of school, additional info - weighted chance. use SPECIFIC_SPELL_POWER, CREATURE_SPELL_POWER or CREATURE_ENCHANT_POWER for calculating the power*/
    public var CATAPULT:Int = 89; //
    public var ENEMY_DEFENCE_REDUCTION:Int = 90; //in % (value) eg. behemots*/
    public var GENERAL_DAMAGE_REDUCTION:Int = 91; //shield / air shield effect */
    public var GENERAL_ATTACK_REDUCTION:Int = 92; //eg. while stoned or blinded - in %,// subtype not used, use ONLY_MELEE_FIGHT / DISTANCE_FIGHT*/
    public var DEFENSIVE_STANCE:Int = 93; //val - bonus to defense while defending */
    public var ATTACKS_ALL_ADJACENT:Int = 94; //eg. hydra*/
    public var MORE_DAMAGE_FROM_SPELL:Int = 95; //value - damage increase in %, subtype - spell id*/
    public var FEAR:Int = 96; //
    public var FEARLESS:Int = 97; //
    public var NO_DISTANCE_PENALTY:Int = 98; //
    public var SELF_LUCK:Int = 99; //halfling*/
    public var ENCHANTER:Int = 100; //for Enchanter spells, val - skill level, subtype - spell id, additionalInfo - cooldown */
    public var HEALER:Int = 101; //
    public var SIEGE_WEAPON:Int = 102; //
    public var HYPNOTIZED:Int = 103; //
    public var NO_RETALIATION:Int = 104; //temporary bonus for basilisk, unicorn and scorpicore paralyze*/
    public var ADDITIONAL_RETALIATION:Int = 105; //value - number of additional retaliations*/
    public var MAGIC_MIRROR:Int = 106; //value - chance of redirecting in %*/
    public var ALWAYS_MINIMUM_DAMAGE:Int = 107; //unit does its minimum damage from range; subtype: -1 - any attack, 0 - melee, 1 - ranged, value: additional damage penalty (it'll subtracted from dmg), additional info - multiplicative anti-bonus for dmg in % [eg 20 means that creature will inflict 80% of normal minimal dmg]*/
    public var ALWAYS_MAXIMUM_DAMAGE:Int = 108; //eg. bless effect, subtype: -1 - any attack, 0 - melee, 1 - ranged, value: additional damage, additional info - multiplicative bonus for dmg in %*/
    public var ATTACKS_NEAREST_CREATURE:Int = 109; //while in berserk*/
    public var IN_FRENZY:Int = 110; //value - level*/
    public var SLAYER:Int = 111; //value - level*/
    public var FORGETFULL:Int = 112; //forgetfulness spell effect, value - level*/
    public var NOT_ACTIVE:Int = 113; //subtype - spell ID (paralyze, blind, stone gaze) for graphical effect*/
    public var NO_LUCK:Int = 114; //eg. when fighting on cursed ground*/
    public var NO_MORALE:Int = 115; //eg. when fighting on cursed ground*/
    public var DARKNESS:Int = 116; //val = radius */
    public var SPECIAL_SECONDARY_SKILL:Int = 117; //subtype = id, val = value per level in percent*/
    public var SPECIAL_SPELL_LEV:Int = 118; //subtype = id, val = value per level in percent*/
    public var SPELL_DAMAGE:Int = 119; //val = value*/
    public var SPECIFIC_SPELL_DAMAGE:Int = 120; //subtype = id of spell, val = value*/
    public var SPECIAL_BLESS_DAMAGE:Int = 121; //val = spell (bless), additionalInfo = value per level in percent*/
    public var MAXED_SPELL:Int = 122; //val = id*/
    public var SPECIAL_PECULIAR_ENCHANT:Int = 123; //blesses and curses with id = val dependent on unit's level, subtype = 0 or 1 for Coronius*/
    public var SPECIAL_UPGRADE:Int = 124; //subtype = base, additionalInfo = target */
    public var DRAGON_NATURE:Int = 125; //
    public var CREATURE_DAMAGE:Int = 126; //subtype 0 = both, 1 = min, 2 = max*/
    public var EXP_MULTIPLIER:Int = 127; //val - percent of additional exp gained by stack/commander (base value 100)*/
    public var SHOTS:Int = 128; //
    public var DEATH_STARE:Int = 129; //subtype 0 - gorgon, 1 - commander*/
    public var POISON:Int = 130; //val - max health penalty from poison possible*/
    public var BIND_EFFECT:Int = 131; //doesn't do anything particular, works as a marker)*/
    public var ACID_BREATH:Int = 132; //additional val damage per creature after attack, additional info - chance in percent*/
    public var RECEPTIVE:Int = 133; //accepts friendly spells even with immunity*/
    public var DIRECT_DAMAGE_IMMUNITY:Int = 134; //direct damage spells, that is*/
    public var CASTS:Int = 135; //how many times creature can cast activated spell*/
    public var SPECIFIC_SPELL_POWER:Int = 136; //value used for Thunderbolt and Resurrection cast by units, subtype - spell id */
    public var CREATURE_SPELL_POWER:Int = 137; //value per unit, divided by 100 (so faerie Dragons have 800)*/
    public var CREATURE_ENCHANT_POWER:Int = 138; //total duration of spells cast by creature */
    public var ENCHANTED:Int = 139; //permanently enchanted with spell subID of level = val, if val > 3 then spell is mass and has level of val-3*/
    public var REBIRTH:Int = 140; //val - percent of life restored, subtype = 0 - regular, 1 - at least one unit (sacred Phoenix) */
    public var ADDITIONAL_UNITS:Int = 141; //val of units with id = subtype will be added to hero's army at the beginning of battle */
    public var SPOILS_OF_WAR:Int = 142; //val * 10^-6 * gained exp resources of subtype will be given to hero after battle*/
    public var BLOCK:Int = 143; //
    public var DISGUISED:Int = 144; //subtype - spell level */
    public var VISIONS:Int = 145; //subtype - spell level */
    public var NO_TERRAIN_PENALTY:Int = 146; //subtype - terrain type */
    public var SOUL_STEAL:Int = 147; //val - number of units gained per enemy killed, subtype = 0 - gained units survive after battle, 1 - they do not*/
    public var TRANSMUTATION:Int = 148; //val - chance to trigger in %, subtype = 0 - resurrection based on HP, 1 - based on unit count, additional info - target creature ID (attacker default)*/
    public var SUMMON_GUARDIANS:Int = 149; //val - amount in % of stack count, subtype = creature ID*/
    public var CATAPULT_EXTRA_SHOTS:Int = 150; //val - number of additional shots, requires CATAPULT bonus to work*/
    public var RANGED_RETALIATION:Int = 151; //allows shooters to perform ranged retaliation*/
    public var BLOCKS_RANGED_RETALIATION:Int = 152; //disallows ranged retaliation for shooter unit, BLOCKS_RETALIATION bonus is for melee retaliation only*/
    public var SECONDARY_SKILL_VAL2:Int = 153; //for secondary skills that have multiple effects, like eagle eye (max level and chance)*/
    public var MANUAL_CONTROL:Int = 154; //manually control warmachine with id = subtype, chance = val */
    public var WIDE_BREATH:Int = 155; //initial desigh: dragon breath affecting multiple nearby hexes */
    public var FIRST_STRIKE:Int = 156; //first counterattack, then attack if possible */
    public var SYNERGY_TARGET:Int = 157; //dummy skill for alternative upgrades mod */
    public var SHOOTS_ALL_ADJACENT:Int = 158; //H4 Cyclops-like shoot (attacks all hexes neighboring with target) without spell-like mechanics */
    public var BLOCK_MAGIC_BELOW:Int = 159; //blocks casting spells of the level < value */
    public var DESTRUCTION:Int = 160; //kills extra units after hit, subtype = 0 - kill percentage of units, 1 - kill amount, val = chance in percent to trigger, additional info - amount/percentage to kill*/

    public static function parse(s:String):BonusType {
        return switch (s) {
            case "NONE": NONE;
            case "LEVEL_COUNTER": LEVEL_COUNTER;
            case "MOVEMENT": MOVEMENT;
            case "LAND_MOVEMENT": LAND_MOVEMENT;
            case "SEA_MOVEMENT": SEA_MOVEMENT;
            case "MORALE": MORALE;
            case "LUCK": LUCK;
            case "PRIMARY_SKILL": PRIMARY_SKILL;
            case "SIGHT_RADIOUS": SIGHT_RADIOUS;
            case "MANA_REGENERATION": MANA_REGENERATION;
            case "FULL_MANA_REGENERATION": FULL_MANA_REGENERATION;
            case "NONEVIL_ALIGNMENT_MIX": NONEVIL_ALIGNMENT_MIX;
            case "SECONDARY_SKILL_PREMY": SECONDARY_SKILL_PREMY;
            case "SURRENDER_DISCOUNT": SURRENDER_DISCOUNT;
            case "STACKS_SPEED": STACKS_SPEED;
            case "FLYING_MOVEMENT": FLYING_MOVEMENT;
            case "SPELL_DURATION": SPELL_DURATION;
            case "AIR_SPELL_DMG_PREMY": AIR_SPELL_DMG_PREMY;
            case "EARTH_SPELL_DMG_PREMY": EARTH_SPELL_DMG_PREMY;
            case "FIRE_SPELL_DMG_PREMY": FIRE_SPELL_DMG_PREMY;
            case "WATER_SPELL_DMG_PREMY": WATER_SPELL_DMG_PREMY;
            case "WATER_WALKING": WATER_WALKING;
            case "NEGATE_ALL_NATURAL_IMMUNITIES": NEGATE_ALL_NATURAL_IMMUNITIES;
            case "STACK_HEALTH": STACK_HEALTH;
            case "BLOCK_MORALE": BLOCK_MORALE;
            case "BLOCK_LUCK": BLOCK_LUCK;
            case "FIRE_SPELLS": FIRE_SPELLS;
            case "AIR_SPELLS": AIR_SPELLS;
            case "WATER_SPELLS": WATER_SPELLS;
            case "EARTH_SPELLS": EARTH_SPELLS;
            case "GENERATE_RESOURCE": GENERATE_RESOURCE;
            case "CREATURE_GROWTH": CREATURE_GROWTH;
            case "WHIRLPOOL_PROTECTION": WHIRLPOOL_PROTECTION;
            case "SPELL": SPELL;
            case "SPELLS_OF_LEVEL": SPELLS_OF_LEVEL;
            case "BATTLE_NO_FLEEING": BATTLE_NO_FLEEING;
            case "MAGIC_SCHOOL_SKILL": MAGIC_SCHOOL_SKILL;
            case "FREE_SHOOTING": FREE_SHOOTING;
            case "OPENING_BATTLE_SPELL": OPENING_BATTLE_SPELL;
            case "IMPROVED_NECROMANCY": IMPROVED_NECROMANCY;
            case "CREATURE_GROWTH_PERCENT": CREATURE_GROWTH_PERCENT;
            case "FREE_SHIP_BOARDING": FREE_SHIP_BOARDING;
            case "NO_TYPE": NO_TYPE;
            case "FLYING": FLYING;
            case "SHOOTER": SHOOTER;
            case "CHARGE_IMMUNITY": CHARGE_IMMUNITY;
            case "ADDITIONAL_ATTACK": ADDITIONAL_ATTACK;
            case "UNLIMITED_RETALIATIONS": UNLIMITED_RETALIATIONS;
            case "NO_MELEE_PENALTY": NO_MELEE_PENALTY;
            case "JOUSTING": JOUSTING;
            case "HATE": HATE;
            case "KING1": KING1;
            case "KING2": KING2;
            case "KING3": KING3;
            case "MAGIC_RESISTANCE": MAGIC_RESISTANCE;
            case "CHANGES_SPELL_COST_FOR_ALLY": CHANGES_SPELL_COST_FOR_ALLY;
            case "CHANGES_SPELL_COST_FOR_ENEMY": CHANGES_SPELL_COST_FOR_ENEMY;
            case "SPELL_AFTER_ATTACK": SPELL_AFTER_ATTACK;
            case "SPELL_BEFORE_ATTACK": SPELL_BEFORE_ATTACK;
            case "SPELL_RESISTANCE_AURA": SPELL_RESISTANCE_AURA;
            case "LEVEL_SPELL_IMMUNITY": LEVEL_SPELL_IMMUNITY;
            case "BLOCK_MAGIC_ABOVE": BLOCK_MAGIC_ABOVE;
            case "BLOCK_ALL_MAGIC": BLOCK_ALL_MAGIC;
            case "TWO_HEX_ATTACK_BREATH": TWO_HEX_ATTACK_BREATH;
            case "SPELL_DAMAGE_REDUCTION": SPELL_DAMAGE_REDUCTION;
            case "NO_WALL_PENALTY": NO_WALL_PENALTY;
            case "NON_LIVING": NON_LIVING;
            case "RANDOM_SPELLCASTER": RANDOM_SPELLCASTER;
            case "BLOCKS_RETALIATION": BLOCKS_RETALIATION;
            case "SPELL_IMMUNITY": SPELL_IMMUNITY;
            case "MANA_CHANNELING": MANA_CHANNELING;
            case "SPELL_LIKE_ATTACK": SPELL_LIKE_ATTACK;
            case "THREE_HEADED_ATTACK": THREE_HEADED_ATTACK;
            case "DAEMON_SUMMONING": DAEMON_SUMMONING;
            case "FIRE_IMMUNITY": FIRE_IMMUNITY;
            case "WATER_IMMUNITY": WATER_IMMUNITY;
            case "EARTH_IMMUNITY": EARTH_IMMUNITY;
            case "AIR_IMMUNITY": AIR_IMMUNITY;
            case "MIND_IMMUNITY": MIND_IMMUNITY;
            case "FIRE_SHIELD": FIRE_SHIELD;
            case "UNDEAD": UNDEAD;
            case "HP_REGENERATION": HP_REGENERATION;
            case "FULL_HP_REGENERATION": FULL_HP_REGENERATION;
            case "MANA_DRAIN": MANA_DRAIN;
            case "LIFE_DRAIN": LIFE_DRAIN;
            case "DOUBLE_DAMAGE_CHANCE": DOUBLE_DAMAGE_CHANCE;
            case "RETURN_AFTER_STRIKE": RETURN_AFTER_STRIKE;
            case "SELF_MORALE": SELF_MORALE;
            case "SPELLCASTER": SPELLCASTER;
            case "CATAPULT": CATAPULT;
            case "ENEMY_DEFENCE_REDUCTION": ENEMY_DEFENCE_REDUCTION;
            case "GENERAL_DAMAGE_REDUCTION": GENERAL_DAMAGE_REDUCTION;
            case "GENERAL_ATTACK_REDUCTION": GENERAL_ATTACK_REDUCTION;
            case "DEFENSIVE_STANCE": DEFENSIVE_STANCE;
            case "ATTACKS_ALL_ADJACENT": ATTACKS_ALL_ADJACENT;
            case "MORE_DAMAGE_FROM_SPELL": MORE_DAMAGE_FROM_SPELL;
            case "FEAR": FEAR;
            case "FEARLESS": FEARLESS;
            case "NO_DISTANCE_PENALTY": NO_DISTANCE_PENALTY;
            case "SELF_LUCK": SELF_LUCK;
            case "ENCHANTER": ENCHANTER;
            case "HEALER": HEALER;
            case "SIEGE_WEAPON": SIEGE_WEAPON;
            case "HYPNOTIZED": HYPNOTIZED;
            case "NO_RETALIATION": NO_RETALIATION;
            case "ADDITIONAL_RETALIATION": ADDITIONAL_RETALIATION;
            case "MAGIC_MIRROR": MAGIC_MIRROR;
            case "ALWAYS_MINIMUM_DAMAGE": ALWAYS_MINIMUM_DAMAGE;
            case "ALWAYS_MAXIMUM_DAMAGE": ALWAYS_MAXIMUM_DAMAGE;
            case "ATTACKS_NEAREST_CREATURE": ATTACKS_NEAREST_CREATURE;
            case "IN_FRENZY": IN_FRENZY;
            case "SLAYER": SLAYER;
            case "FORGETFULL": FORGETFULL;
            case "NOT_ACTIVE": NOT_ACTIVE;
            case "NO_LUCK": NO_LUCK;
            case "NO_MORALE": NO_MORALE;
            case "DARKNESS": DARKNESS;
            case "SPECIAL_SECONDARY_SKILL": SPECIAL_SECONDARY_SKILL;
            case "SPECIAL_SPELL_LEV": SPECIAL_SPELL_LEV;
            case "SPELL_DAMAGE": SPELL_DAMAGE;
            case "SPECIFIC_SPELL_DAMAGE": SPECIFIC_SPELL_DAMAGE;
            case "SPECIAL_BLESS_DAMAGE": SPECIAL_BLESS_DAMAGE;
            case "MAXED_SPELL": MAXED_SPELL;
            case "SPECIAL_PECULIAR_ENCHANT": SPECIAL_PECULIAR_ENCHANT;
            case "SPECIAL_UPGRADE": SPECIAL_UPGRADE;
            case "DRAGON_NATURE": DRAGON_NATURE;
            case "CREATURE_DAMAGE": CREATURE_DAMAGE;
            case "EXP_MULTIPLIER": EXP_MULTIPLIER;
            case "SHOTS": SHOTS;
            case "DEATH_STARE": DEATH_STARE;
            case "POISON": POISON;
            case "BIND_EFFECT": BIND_EFFECT;
            case "ACID_BREATH": ACID_BREATH;
            case "RECEPTIVE": RECEPTIVE;
            case "DIRECT_DAMAGE_IMMUNITY": DIRECT_DAMAGE_IMMUNITY;
            case "CASTS": CASTS;
            case "SPECIFIC_SPELL_POWER": SPECIFIC_SPELL_POWER;
            case "CREATURE_SPELL_POWER": CREATURE_SPELL_POWER;
            case "CREATURE_ENCHANT_POWER": CREATURE_ENCHANT_POWER;
            case "ENCHANTED": ENCHANTED;
            case "REBIRTH": REBIRTH;
            case "ADDITIONAL_UNITS": ADDITIONAL_UNITS;
            case "SPOILS_OF_WAR": SPOILS_OF_WAR;
            case "BLOCK": BLOCK;
            case "DISGUISED": DISGUISED;
            case "VISIONS": VISIONS;
            case "NO_TERRAIN_PENALTY": NO_TERRAIN_PENALTY;
            case "SOUL_STEAL": SOUL_STEAL;
            case "TRANSMUTATION": TRANSMUTATION;
            case "SUMMON_GUARDIANS": SUMMON_GUARDIANS;
            case "CATAPULT_EXTRA_SHOTS": CATAPULT_EXTRA_SHOTS;
            case "RANGED_RETALIATION": RANGED_RETALIATION;
            case "BLOCKS_RANGED_RETALIATION": BLOCKS_RANGED_RETALIATION;
            case "SECONDARY_SKILL_VAL2": SECONDARY_SKILL_VAL2;
            case "MANUAL_CONTROL": MANUAL_CONTROL;
            case "WIDE_BREATH": WIDE_BREATH;
            case "FIRST_STRIKE": FIRST_STRIKE;
            case "SYNERGY_TARGET": SYNERGY_TARGET;
            case "SHOOTS_ALL_ADJACENT": SHOOTS_ALL_ADJACENT;
            case "BLOCK_MAGIC_BELOW": BLOCK_MAGIC_BELOW;
            case "DESTRUCTION": DESTRUCTION;
            default: UNDEFINED;
        }
    }

    public function toString():String {
        return switch(this) {
            case NONE: "NONE";
            case LEVEL_COUNTER: "LEVEL_COUNTER";
            case MOVEMENT: "MOVEMENT";
            case LAND_MOVEMENT: "LAND_MOVEMENT";
            case SEA_MOVEMENT: "SEA_MOVEMENT";
            case MORALE: "MORALE";
            case LUCK: "LUCK";
            case PRIMARY_SKILL: "PRIMARY_SKILL";
            case SIGHT_RADIOUS: "SIGHT_RADIOUS";
            case MANA_REGENERATION: "MANA_REGENERATION";
            case FULL_MANA_REGENERATION: "FULL_MANA_REGENERATION";
            case NONEVIL_ALIGNMENT_MIX: "NONEVIL_ALIGNMENT_MIX";
            case SECONDARY_SKILL_PREMY: "SECONDARY_SKILL_PREMY";
            case SURRENDER_DISCOUNT: "SURRENDER_DISCOUNT";
            case STACKS_SPEED: "STACKS_SPEED";
            case FLYING_MOVEMENT: "FLYING_MOVEMENT";
            case SPELL_DURATION: "SPELL_DURATION";
            case AIR_SPELL_DMG_PREMY: "AIR_SPELL_DMG_PREMY";
            case EARTH_SPELL_DMG_PREMY: "EARTH_SPELL_DMG_PREMY";
            case FIRE_SPELL_DMG_PREMY: "FIRE_SPELL_DMG_PREMY";
            case WATER_SPELL_DMG_PREMY: "WATER_SPELL_DMG_PREMY";
            case WATER_WALKING: "WATER_WALKING";
            case NEGATE_ALL_NATURAL_IMMUNITIES: "NEGATE_ALL_NATURAL_IMMUNITIES";
            case STACK_HEALTH: "STACK_HEALTH";
            case BLOCK_MORALE: "BLOCK_MORALE";
            case BLOCK_LUCK: "BLOCK_LUCK";
            case FIRE_SPELLS: "FIRE_SPELLS";
            case AIR_SPELLS: "AIR_SPELLS";
            case WATER_SPELLS: "WATER_SPELLS";
            case EARTH_SPELLS: "EARTH_SPELLS";
            case GENERATE_RESOURCE: "GENERATE_RESOURCE";
            case CREATURE_GROWTH: "CREATURE_GROWTH";
            case WHIRLPOOL_PROTECTION: "WHIRLPOOL_PROTECTION";
            case SPELL: "SPELL";
            case SPELLS_OF_LEVEL: "SPELLS_OF_LEVEL";
            case BATTLE_NO_FLEEING: "BATTLE_NO_FLEEING";
            case MAGIC_SCHOOL_SKILL: "MAGIC_SCHOOL_SKILL";
            case FREE_SHOOTING: "FREE_SHOOTING";
            case OPENING_BATTLE_SPELL: "OPENING_BATTLE_SPELL";
            case IMPROVED_NECROMANCY: "IMPROVED_NECROMANCY";
            case CREATURE_GROWTH_PERCENT: "CREATURE_GROWTH_PERCENT";
            case FREE_SHIP_BOARDING: "FREE_SHIP_BOARDING";
            case NO_TYPE: "NO_TYPE";
            case FLYING: "FLYING";
            case SHOOTER: "SHOOTER";
            case CHARGE_IMMUNITY: "CHARGE_IMMUNITY";
            case ADDITIONAL_ATTACK: "ADDITIONAL_ATTACK";
            case UNLIMITED_RETALIATIONS: "UNLIMITED_RETALIATIONS";
            case NO_MELEE_PENALTY: "NO_MELEE_PENALTY";
            case JOUSTING: "JOUSTING";
            case HATE: "HATE";
            case KING1: "KING1";
            case KING2: "KING2";
            case KING3: "KING3";
            case MAGIC_RESISTANCE: "MAGIC_RESISTANCE";
            case CHANGES_SPELL_COST_FOR_ALLY: "CHANGES_SPELL_COST_FOR_ALLY";
            case CHANGES_SPELL_COST_FOR_ENEMY: "CHANGES_SPELL_COST_FOR_ENEMY";
            case SPELL_AFTER_ATTACK: "SPELL_AFTER_ATTACK";
            case SPELL_BEFORE_ATTACK: "SPELL_BEFORE_ATTACK";
            case SPELL_RESISTANCE_AURA: "SPELL_RESISTANCE_AURA";
            case LEVEL_SPELL_IMMUNITY: "LEVEL_SPELL_IMMUNITY";
            case BLOCK_MAGIC_ABOVE: "BLOCK_MAGIC_ABOVE";
            case BLOCK_ALL_MAGIC: "BLOCK_ALL_MAGIC";
            case TWO_HEX_ATTACK_BREATH: "TWO_HEX_ATTACK_BREATH";
            case SPELL_DAMAGE_REDUCTION: "SPELL_DAMAGE_REDUCTION";
            case NO_WALL_PENALTY: "NO_WALL_PENALTY";
            case NON_LIVING: "NON_LIVING";
            case RANDOM_SPELLCASTER: "RANDOM_SPELLCASTER";
            case BLOCKS_RETALIATION: "BLOCKS_RETALIATION";
            case SPELL_IMMUNITY: "SPELL_IMMUNITY";
            case MANA_CHANNELING: "MANA_CHANNELING";
            case SPELL_LIKE_ATTACK: "SPELL_LIKE_ATTACK";
            case THREE_HEADED_ATTACK: "THREE_HEADED_ATTACK";
            case DAEMON_SUMMONING: "DAEMON_SUMMONING";
            case FIRE_IMMUNITY: "FIRE_IMMUNITY";
            case WATER_IMMUNITY: "WATER_IMMUNITY";
            case EARTH_IMMUNITY: "EARTH_IMMUNITY";
            case AIR_IMMUNITY: "AIR_IMMUNITY";
            case MIND_IMMUNITY: "MIND_IMMUNITY";
            case FIRE_SHIELD: "FIRE_SHIELD";
            case UNDEAD: "UNDEAD";
            case HP_REGENERATION: "HP_REGENERATION";
            case FULL_HP_REGENERATION: "FULL_HP_REGENERATION";
            case MANA_DRAIN: "MANA_DRAIN";
            case LIFE_DRAIN: "LIFE_DRAIN";
            case DOUBLE_DAMAGE_CHANCE: "DOUBLE_DAMAGE_CHANCE";
            case RETURN_AFTER_STRIKE: "RETURN_AFTER_STRIKE";
            case SELF_MORALE: "SELF_MORALE";
            case SPELLCASTER: "SPELLCASTER";
            case CATAPULT: "CATAPULT";
            case ENEMY_DEFENCE_REDUCTION: "ENEMY_DEFENCE_REDUCTION";
            case GENERAL_DAMAGE_REDUCTION: "GENERAL_DAMAGE_REDUCTION";
            case GENERAL_ATTACK_REDUCTION: "GENERAL_ATTACK_REDUCTION";
            case DEFENSIVE_STANCE: "DEFENSIVE_STANCE";
            case ATTACKS_ALL_ADJACENT: "ATTACKS_ALL_ADJACENT";
            case MORE_DAMAGE_FROM_SPELL: "MORE_DAMAGE_FROM_SPELL";
            case FEAR: "FEAR";
            case FEARLESS: "FEARLESS";
            case NO_DISTANCE_PENALTY: "NO_DISTANCE_PENALTY";
            case SELF_LUCK: "SELF_LUCK";
            case ENCHANTER: "ENCHANTER";
            case HEALER: "HEALER";
            case SIEGE_WEAPON: "SIEGE_WEAPON";
            case HYPNOTIZED: "HYPNOTIZED";
            case NO_RETALIATION: "NO_RETALIATION";
            case ADDITIONAL_RETALIATION: "ADDITIONAL_RETALIATION";
            case MAGIC_MIRROR: "MAGIC_MIRROR";
            case ALWAYS_MINIMUM_DAMAGE: "ALWAYS_MINIMUM_DAMAGE";
            case ALWAYS_MAXIMUM_DAMAGE: "ALWAYS_MAXIMUM_DAMAGE";
            case ATTACKS_NEAREST_CREATURE: "ATTACKS_NEAREST_CREATURE";
            case IN_FRENZY: "IN_FRENZY";
            case SLAYER: "SLAYER";
            case FORGETFULL: "FORGETFULL";
            case NOT_ACTIVE: "NOT_ACTIVE";
            case NO_LUCK: "NO_LUCK";
            case NO_MORALE: "NO_MORALE";
            case DARKNESS: "DARKNESS";
            case SPECIAL_SECONDARY_SKILL: "SPECIAL_SECONDARY_SKILL";
            case SPECIAL_SPELL_LEV: "SPECIAL_SPELL_LEV";
            case SPELL_DAMAGE: "SPELL_DAMAGE";
            case SPECIFIC_SPELL_DAMAGE: "SPECIFIC_SPELL_DAMAGE";
            case SPECIAL_BLESS_DAMAGE: "SPECIAL_BLESS_DAMAGE";
            case MAXED_SPELL: "MAXED_SPELL";
            case SPECIAL_PECULIAR_ENCHANT: "SPECIAL_PECULIAR_ENCHANT";
            case SPECIAL_UPGRADE: "SPECIAL_UPGRADE";
            case DRAGON_NATURE: "DRAGON_NATURE";
            case CREATURE_DAMAGE: "CREATURE_DAMAGE";
            case EXP_MULTIPLIER: "EXP_MULTIPLIER";
            case SHOTS: "SHOTS";
            case DEATH_STARE: "DEATH_STARE";
            case POISON: "POISON";
            case BIND_EFFECT: "BIND_EFFECT";
            case ACID_BREATH: "ACID_BREATH";
            case RECEPTIVE: "RECEPTIVE";
            case DIRECT_DAMAGE_IMMUNITY: "DIRECT_DAMAGE_IMMUNITY";
            case CASTS: "CASTS";
            case SPECIFIC_SPELL_POWER: "SPECIFIC_SPELL_POWER";
            case CREATURE_SPELL_POWER: "CREATURE_SPELL_POWER";
            case CREATURE_ENCHANT_POWER: "CREATURE_ENCHANT_POWER";
            case ENCHANTED: "ENCHANTED";
            case REBIRTH: "REBIRTH";
            case ADDITIONAL_UNITS: "ADDITIONAL_UNITS";
            case SPOILS_OF_WAR: "SPOILS_OF_WAR";
            case BLOCK: "BLOCK";
            case DISGUISED: "DISGUISED";
            case VISIONS: "VISIONS";
            case NO_TERRAIN_PENALTY: "NO_TERRAIN_PENALTY";
            case SOUL_STEAL: "SOUL_STEAL";
            case TRANSMUTATION: "TRANSMUTATION";
            case SUMMON_GUARDIANS: "SUMMON_GUARDIANS";
            case CATAPULT_EXTRA_SHOTS: "CATAPULT_EXTRA_SHOTS";
            case RANGED_RETALIATION: "RANGED_RETALIATION";
            case BLOCKS_RANGED_RETALIATION: "BLOCKS_RANGED_RETALIATION";
            case SECONDARY_SKILL_VAL2: "SECONDARY_SKILL_VAL2";
            case MANUAL_CONTROL: "MANUAL_CONTROL";
            case WIDE_BREATH: "WIDE_BREATH";
            case FIRST_STRIKE: "FIRST_STRIKE";
            case SYNERGY_TARGET: "SYNERGY_TARGET";
            case SHOOTS_ALL_ADJACENT: "SHOOTS_ALL_ADJACENT";
            case BLOCK_MAGIC_BELOW: "BLOCK_MAGIC_BELOW";
            case DESTRUCTION: "DESTRUCTION";
            default: "UNDEFINED";
        }
    }
}
