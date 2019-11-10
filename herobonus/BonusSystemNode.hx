package lib.herobonus;

typedef NodesVector = Array<BonusSystemNode>;

class BonusSystemNode {

    private var bonuses:BonusList; //wielded bonuses (local or up-propagated here)
    private var exportedBonuses:BonusList; //bonuses coming from this node (wielded or propagated away)

    private var parents:NodesVector; //parents -> we inherit bonuses from them, we may attach our bonuses to them
    private var children:NodesVector;

    private var nodeType:BonusSystemNodeType;
    private var description:String;

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
}
