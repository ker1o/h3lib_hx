package lib.herobonus;

typedef NodesVector = Array<BonusSystemNode>;

class BonusSystemNode {

    private var bonuses:BonusList; //wielded bonuses (local or up-propagated here)
    private var exportedBonuses:BonusList; //bonuses coming from this node (wielded or propagated away)

    private var parents:NodesVector; //parents -> we inherit bonuses from them, we may attach our bonuses to them
    private var children:NodesVector;

    private var nodeType:BonusSystemNodeType;
    private var nodeDescription:String;

    static private var cachingEnabled:Bool;
    private var cachedBonuses:BonusList;
    private var cachedLast:Int; // Int64
    static private var treeChanged:Int;

    // Setting a value to cachingStr before getting any bonuses caches the result for later requests.
    // This string needs to be unique, that's why it has to be setted in the following manner:
    // [property key]_[value] => only for selector
    private var cachedRequests:Map<String, BonusList>;
    
    public function new() {
    }

    public function setNodeType(type:BonusSystemNodeType) {
        nodeType = type;
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

        for(bonusSystemNode in getRedChildren()) {
            bonusSystemNode.propagateBonus(b);
        }
    }

    public function newChildAttached(child:BonusSystemNode) {
        children.push(child);

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


    public function getParents():Array<BonusSystemNode> {
        var out:Array<BonusSystemNode> = [];
        for (elem in parents) {
            var parent:BonusSystemNode = elem;
            out.push(parent);
        }
        return out;
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

}
