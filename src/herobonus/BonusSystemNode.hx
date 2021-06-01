package herobonus;

import constants.PrimarySkill;
import herobonus.selector.Selector.BonusSelector;
typedef NodesVector = Array<BonusSystemNode>;

class BonusSystemNode extends BonusBearer {

    private var bonuses:BonusList; //wielded bonuses (local or up-propagated here)
    private var exportedBonuses:BonusList; //bonuses coming from this node (wielded or propagated away)

    private var parents:NodesVector; //parents -> we inherit bonuses from them, we may attach our bonuses to them
    private var children:NodesVector;

    private var nodeType:BonusSystemNodeType;
    private var nodeDescription:String;

    static private var cachingEnabled:Bool;
    private var cachedBonuses:BonusList;
    private var cachedLast:Int; // Int64
    private static var treeChanged:Int;

    // Setting a value to cachingStr before getting any bonuses caches the result for later requests.
    // This string needs to be unique, that's why it has to be setted in the following manner:
    // [property key]_[value] => only for selector
    private var cachedRequests:Map<String, BonusList>;

    public function new(nodeType:BonusSystemNodeType = BonusSystemNodeType.UNKNOWN, ?other:BonusSystemNode) {
        super();

        if (other != null) {
            // can we just assign? or copy?
            bonuses = other.bonuses;
            exportedBonuses = other.exportedBonuses;
            this.nodeType = other.nodeType;
            nodeDescription = other.nodeDescription;
            parents = other.parents;
            children = other.children;

            //fixing bonus tree without recalculation

            for(bonusSystemNode in parents) {
                bonusSystemNode.children.remove(other);
                bonusSystemNode.children.push(this);
            }

            for(bonusSystemNode in children) {
                bonusSystemNode.parents.remove(other);
                bonusSystemNode.parents.push(this);
            }
        } else {
            bonuses = new BonusList();
            exportedBonuses = new BonusList();
            parents = new NodesVector();
            children = new NodesVector();
            this.nodeType = nodeType;
            nodeDescription = "";
        }
        cachedLast = 0;
    }

    // ToDo: make getter
    public function getBonusList():BonusList {
        return bonuses;
    }

    public function getExportedBonusList():BonusList {
        return exportedBonuses;
    }

    public function setDescription(description:String) {
        nodeDescription = description;
    }

    public function detachFrom(parent:BonusSystemNode) {
        if(parent.actsAsBonusSourceOnly()) {
            parent.removedRedDescendant(this);
        } else {
            removedRedDescendant(parent);
        }

        parents.remove(parent);
        parent.childDetached(this);
        treeHasChanged();
    }

    public inline function setNodeType(type:BonusSystemNodeType) {
        nodeType = type;
    }

    public inline function getNodeType():BonusSystemNodeType {
        return nodeType;
    }

    public function addNewBonus(b:Bonus) : Void {
        //turnsRemain shouldn't be zero for following durations
        if(Bonus.nTurns(b) || Bonus.nDays(b) || Bonus.oneWeek(b)) {
//            assert(b.turnsRemain);
        }

        //assert(!vstd::contains(exportedBonuses, b));
        exportedBonuses.push(b);
        exportBonus(b);
        treeHasChanged();
    }

    public function removeBonus(b:Bonus) {
        exportedBonuses.remove(b);
        if(b.propagator != null) {
            unpropagateBonus(b);
        } else {
            bonuses.remove(b);
        }
        treeHasChanged();
    }

    public function exportBonus(b:Bonus) {
        if(b.propagator != null)
            propagateBonus(b);
        else
            bonuses.push(b);
        treeHasChanged();
    }

    public function propagateBonus(b:Bonus) {
        if(b.propagator.shouldBeAttached(this)) {
            bonuses.push(b);
//            logBonus->trace("#$# %s #propagated to# %s",  b->Description(), nodeName());
        }

        forEachRedChild(function(child:BonusSystemNode) {
            child.propagateBonus(b);
        });
    }

    public function unpropagateBonus(b:Bonus) {
        if(b.propagator.shouldBeAttached(this)) {
            bonuses.remove(b);
//            logBonus->trace("#$# %s #is no longer propagated to# %s",  b->Description(), nodeName());
        }

        forEachRedChild(function(child:BonusSystemNode) {
            child.unpropagateBonus(b);
        });
    }

    public function newChildAttached(child:BonusSystemNode) {
        children.push(child);
    }

    public function childDetached(child:BonusSystemNode) {
        if (children.indexOf(child) > -1) {
            children.remove(child);
        } else {
//            logBonus->error("Error! %s #cannot be detached from# %s", child->nodeName(), nodeName());
            throw "internal error";
        }
    }


    public static function treeHasChanged():Void {
        treeChanged++;
    }

    public function getRedParents():Array<BonusSystemNode> {
        var out:Array<BonusSystemNode> = [];
        forEachParent(function(pname) {
            if(pname.actsAsBonusSourceOnly()) {
                out.push(pname);
            }
        });

        if(!actsAsBonusSourceOnly()) {
            for(child in children) {
                out.push(child);
            }
        }
        return out;
    }

    public function getRedChildren():Array<BonusSystemNode> {
        var out:Array<BonusSystemNode> = [];
        forEachParent(function(pname) {
            if(!pname.actsAsBonusSourceOnly()) {
                out.push(pname);
            }
        });

        if(actsAsBonusSourceOnly()) {
            for(child in children) {
                out.push(child);
            }
        }
        return out;
    }

    public function newRedDescendant(descendant:BonusSystemNode):Void {
        for (b in exportedBonuses) {
            if(b.propagator != null) descendant.propagateBonus(b);
        }

        forEachRedParent(function(parent) {
            parent.newRedDescendant(descendant);
        });
    }

    public function removedRedDescendant(descendant:BonusSystemNode):Void {
        for (b in exportedBonuses) {
            if(b.propagator != null) descendant.unpropagateBonus(b);
        }

        forEachRedParent(function(parent) {
            parent.removedRedDescendant(descendant);
        });
    }

    public function getParents():Array<BonusSystemNode> {
        var out:Array<BonusSystemNode> = [];
        for (elem in parents) {
            var parent:BonusSystemNode = elem;
            out.push(parent);
        }
        return out;
    }

    public function getChildrenNodes() {
        return children;
    }

    public function actsAsBonusSourceOnly():Bool {
        return switch(nodeType) {
            case BonusSystemNodeType.CREATURE | BonusSystemNodeType.ARTIFACT | BonusSystemNodeType.ARTIFACT_INSTANCE:
                true;
            default:
                false;
        }
    }

    public function attachTo(parent:BonusSystemNode):Void {
        parents.push(parent);
        if (parent.actsAsBonusSourceOnly()) {
            parent.newRedDescendant(this);
        } else {
            newRedDescendant(parent);
        }
        parent.newChildAttached(this);
        treeHasChanged();
    }

    private inline function forEachParent(func:BonusSystemNode->Void) {
        for(pname in getParents()) {
            func(pname);
        }
    }

    private inline function forEachRedChild(func:BonusSystemNode->Void) {
        for(pname in getRedChildren()) {
            func(pname);
        }
    }

    private inline function forEachRedParent(func:BonusSystemNode->Void) {
        for(pname in getRedParents()) {
            func(pname);
        }
    }

    public function getBonusLocalFirst(selector:BonusSelector) {
        var ret = bonuses.getFirst(selector);
        if (ret != null) {
            return ret;
        }

        for(pname in getParents()) {
            ret = pname.getBonusLocalFirst(selector);
            if (ret != null) {
                return ret;
            }
        };

        return null;
    }

    public function removeBonuses(selector:BonusSelector) {
        var toRemove:BonusList = new BonusList();
        exportedBonuses.getBonuses(toRemove, selector, BonusSelector.getAll());
        for (bonus in toRemove)
            removeBonus(bonus);
    }

    private function getAllBonusesWithoutCaching(selector:BonusSelector, limit:BonusSelector, root:BonusSystemNode):BonusList
    {
        var ret = new BonusList();

        // Get bonus results without caching enabled.
        var beforeLimiting = new BonusList();
        var afterLimiting = new BonusList();
        getAllBonusesRec(beforeLimiting);

        if(root == null || root == this)
        {
            limitBonuses(beforeLimiting, afterLimiting);
        } else if(root != null) {
            //We want to limit our query against an external node. We get all its bonuses,
            // add the ones we're considering and see if they're cut out by limiters
            var rootBonuses = new BonusList();
            var limitedRootBonuses = new BonusList();
            getAllBonusesRec(rootBonuses);

            for (b in beforeLimiting) {
                rootBonuses.push(b);
            }

            root.limitBonuses(rootBonuses, limitedRootBonuses);

            for (b in beforeLimiting)
                if (limitedRootBonuses.indexOf(b) > -1)
                    afterLimiting.push(b);

        }
        afterLimiting.getBonuses(ret, selector, limit);
        ret.stackBonuses();
        return ret;
    }

    function getAllBonusesRec(out:BonusList) {
        var beforeUpdate = new BonusList();
        forEachParent(function(p:BonusSystemNode) {
            p.getAllBonusesRec(beforeUpdate);
        });
        bonuses.getAllBonuses(beforeUpdate);

        for(b in beforeUpdate) {
            out.push(update(b));
        }
    }

    function update(b:Bonus):Bonus {
        if (b.updater != null)
            return b.updater.update(b, this);
        return b;
    }

    function limitBonuses(allBonuses:BonusList, out:BonusList) {
        //assert(allBonuses != out); //todo should it work in-place?

        var undecided:BonusList = allBonuses;
        var accepted:BonusList = out;

        while(true) {
            var undecidedCount:Int = undecided.length;
            var i = 0;
            while(i < undecided.length) {
                var b:Bonus = undecided[i];
                var context:BonusLimitationContext = new BonusLimitationContext(b, this, out, undecided);
                var decision:Int = b.limiter != null ? (b.limiter.limit(context) ? 1 : 0) : LimiterDecision.ACCEPT; //bonuses without limiters will be accepted by default
                if(decision == LimiterDecision.DISCARD)
                {
                    undecided.erase(i);
                    continue;
                }
                else if(decision == LimiterDecision.ACCEPT)
                {
                    accepted.push(b);
                    undecided.erase(i);
                    continue;
                }
                else {
                    //assert(decision == ILimiter.NOT_SURE);
                }
                i++;
            }

            if (undecided.length == undecidedCount) //we haven't moved a single bonus . limiters reached a stable state
                return;
        }
    }

    // IBonusBearer
    override public function getAllBonuses(selector:BonusSelector, limit:BonusSelector, root:BonusSystemNode = null, cachingStr:String = ""):BonusList {
        // ToDo: do we need caching as in original?
        return getAllBonusesWithoutCaching(selector, limit, root);
    }
}
