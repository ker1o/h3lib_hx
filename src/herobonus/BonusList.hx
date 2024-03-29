package herobonus;

import herobonus.selector.Selector.BonusSelector;

@:forward(push, remove, length, iterator, splice, indexOf, sort)
abstract BonusList(Array<Bonus>) from Array<Bonus> to Array<Bonus>{
    public inline function new() {
        this = [];
    }

    public function back():Bonus {
        return this[this.length - 1];
    }

    public function valOfBonuses(select:BonusSelector) {
        var ret:BonusList = new BonusList();
        var limit:BonusSelector = null;
        getBonuses(ret, select, limit);
        return ret.totalValue();
    }

    public function getBonuses(out:BonusList, selector:BonusSelector, limit:BonusSelector = null) {
        for (b in this) {
            //add matching bonuses that matches limit predicate or have NO_LIMIT if no given predicate
            if (selector.check(b) && ((limit == null && b.effectRange == LimitEffect.NO_LIMIT) || (limit != null && limit.check(b))))
            out.push(b);
        }
    }

    public function totalValue():Int {
        var base:Int = 0;
        var percentToBase:Int = 0;
        var percentToAll:Int = 0;
        var additive:Int = 0;
        var indepMax:Int = 0;
        var hasIndepMax:Bool = false;
        var indepMin:Int = 0;
        var hasIndepMin:Bool = false;

        for(b in this) {
            switch(b.valType) {
                case BonusValue.BASE_NUMBER:
                    base += b.val;
                case BonusValue.PERCENT_TO_ALL:
                    percentToAll += b.val;
                case BonusValue.PERCENT_TO_BASE:
                    percentToBase += b.val;
                case BonusValue.ADDITIVE_VALUE:
                    additive += b.val;
                case BonusValue.INDEPENDENT_MAX:
                    if (!hasIndepMax) {
                        indepMax = b.val;
                        hasIndepMax = true;
                    } else {
                        indepMax = cast Math.max(indepMax, b.val);
                    }
                case BonusValue.INDEPENDENT_MIN:
                    if (!hasIndepMin) {
                        indepMin = b.val;
                        hasIndepMin = true;
                    } else {
                        indepMin = cast Math.min(indepMin, b.val);
                    }
            }
        }
        var modifiedBase = base + (base * percentToBase) / 100;
        modifiedBase += additive;
        var valFirst:Int = Std.int((modifiedBase * (100 + percentToAll)) / 100);

        if (hasIndepMin && hasIndepMax) {
            if (!(indepMin < indepMax)) {
                trace("Error! !(indepMin < indepMax)");
            }
        }

        var notIndepBonuses = 0;
        for (b in this) {
            if (b.valType != BonusValue.INDEPENDENT_MAX && b.valType != BonusValue.INDEPENDENT_MIN) {
                notIndepBonuses++;
            }
        };

        if (hasIndepMax) {
            if (notIndepBonuses > 0) {
                valFirst = cast Math.max(valFirst, indepMax);
            } else {
                valFirst = indepMax;
            }
        }
        if (hasIndepMin) {
            if (notIndepBonuses > 0) {
                valFirst = cast Math.min(valFirst, indepMin);
            } else {
                valFirst = indepMin;
            }
        }

        return valFirst;
    }

    public function getFirst(select:BonusSelector) {
        for (b in this) {
            if (select.check(b))
                return b;
        }
        return null;
    }

    public function erase(position:Int) {
        changed();
        return this.splice(position, 1);
    }

    function changed() {
//        if(belongsToTree)
//            BonusSystemNode.treeHasChanged();
    }

    public function getAllBonuses(out:BonusList) {
        for (b in this)
            out.push(b);
    }

    public function stackBonuses() {
        this.sort(function(b1:Bonus, b2:Bonus) {
            if(b1 == b2)
                return 0;
            var result = false;
            if (b1.stacking != b2.stacking) result = b1.stacking < b2.stacking;
            if (b1.type != b2.type) result = (b1.type:Int) < (b2.type:Int);
            if (b1.subtype != b2.subtype) result = b1.subtype < b2.subtype;
            if (b1.valType != b2.valType) result = (b1.valType:Int) < (b2.valType:Int);
            result = b1.val > b2.val;
            //ToDo: check
            return result ? -1 : 1;
        });

        // remove non-stacking
        var next = 1;
        while(next < this.length) {
            var remove = false;
            var last = this[next-1];
            var current = this[next];

            if (current.stacking.length == 0)
                remove = current == last;
            else if(current.stacking == "ALWAYS")
                remove = false;
            else
                remove = current.stacking == last.stacking
                && current.type == last.type
                && current.subtype == last.subtype
                && current.valType == last.valType;

            if(remove)
                erase(next);
            else
                next++;
        }

    }
}
