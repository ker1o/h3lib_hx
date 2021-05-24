package constants;

@:enum abstract CommanderSecondarySkills(Int) from Int to Int {
    var ATTACK:Int;
    var DEFENSE;
    var HEALTH;
    var DAMAGE;
    var SPEED;
    var SPELL_POWER;
    var CASTS;
    var RESISTANCE;
}