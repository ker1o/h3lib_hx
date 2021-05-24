package herobonus.selector;

abstract BonusSelector(Bonus->Bool) from Bonus->Bool to Bonus->Bool {
    public inline function new(f:Bonus->Bool) {
        this = f;
    }

    public function and(rhs:BonusSelector):BonusSelector {
        return function(b:Bonus) { return this(b) && rhs.check(b);};
    }

    public function or(rhs:BonusSelector):BonusSelector {
        return function(b:Bonus) { return this(b) || rhs.check(b);};
    }

    public function check(b:Bonus):Bool {
        return this(b);
    }

    public static function getIdSelector(sid:Int):BonusSelector {
        return new BonusSelector(function(bonus:Bonus) {
            return bonus.sid == sid;
        });
    }

    public static function getTypeSelector(type:BonusType):BonusSelector {
        return new BonusSelector(function(bonus:Bonus) {
            return bonus.type == type;
        });
    }

    public static function getSubTypeSelector(subtype:Int):BonusSelector {
        return new BonusSelector(function(bonus:Bonus) {
            return bonus.subtype == subtype;
        });
    }

    public static function getSourceSelector(source:BonusSource):BonusSelector {
        return new BonusSelector(function(bonus:Bonus) {
            return bonus.source == source;
        });
    }

    public static function getSourceAndIdSelector(source:BonusSource, id:Int) {
        return getSourceSelector(source).and(getIdSelector(id));
    }

    public static function getAll() {
        return new BonusSelector(function(bonus:Bonus) {
            return true;
        });
    }

}

@:forward(and, or, check)
abstract BonusTypeSelector(BonusSelector) from BonusSelector to BonusSelector {
    public inline function new(type:BonusType) {
        this = function(bonus:Bonus) { return bonus.type == type;};
    }
}

@:forward(and, or, check)
abstract BonusSubTypeSelector(BonusSelector) from BonusSelector to BonusSelector {
    public inline function new(subtype:Int) {
        this = function(bonus:Bonus) { return bonus.subtype == subtype;};
    }
}

@:forward(and, or, check)
abstract BonusDurationSelector(BonusSelector) from BonusSelector to BonusSelector {
    public inline function new(duration:BonusDuration) {
        this = function(bonus:Bonus) { return bonus.duration == duration;};
    }
}

@:forward(and, or, check)
abstract BonusSourceSelector(BonusSelector) from BonusSelector to BonusSelector {
    public inline function new(source:BonusSource) {
        this = function(bonus:Bonus) { return bonus.source == source;};
    }
}
