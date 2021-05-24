package herobonus;

import herobonus.selector.Selector.BonusSelector;

class CheckProxy {
    var target:BonusBearer;
    var selector:BonusSelector;

    var cachedLast:Int;
    var hasBonus:Bool;

    public function new(target:BonusBearer = null, selector:BonusSelector = null, other:CheckProxy = null) {
        if (target != null && selector != null) {
            this.target = target;
            this.selector = selector;
            cachedLast = 0;
            hasBonus = false;
        }

        if (other != null) {
            this.target = other.target;
            this.selector = other.selector;
            this.cachedLast = other.cachedLast;
            this.hasBonus = other.hasBonus;
        }
    }
}