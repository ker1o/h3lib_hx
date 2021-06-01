package herobonus;

class Limiter implements ILimiter{
    public function new() {

    }

    public function limit(context:BonusLimitationContext):Bool {
        throw "Implement me!";
    }
}