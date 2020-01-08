package herobonus;

interface ILimiter {
    function limit(context:BonusLimitationContext):Bool;
}
