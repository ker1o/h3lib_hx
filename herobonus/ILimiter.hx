package lib.herobonus;

interface ILimiter {
    function limit(context:BonusLimitationContext):Int;
}
