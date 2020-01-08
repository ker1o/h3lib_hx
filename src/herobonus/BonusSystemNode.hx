package herobonus;

import herobonus.selector.Selector.BonusSelector;
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
    private var treeChanged:Int;

    // Setting a value to cachingStr before getting any bonuses caches the result for later requests.
    // This string needs to be unique, that's why it has to be setted in the following manner:
    // [property key]_[value] => only for selector
    private var cachedRequests:Map<String, BonusList>;
    
    public function new(nodeType:BonusSystemNodeType = BonusSystemNodeType.UNKNOWN, ?other:BonusSystemNode) {
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


    public function treeHasChanged():Void {
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

    public function getAllBonuses(selector:BonusSelector, linit:BonusSelector, root:BonusSystemNode = null, cachingStr:String = ""):BonusList {
        //ToDo
        return new BonusList();
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
