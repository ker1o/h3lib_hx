package mapObjects.rewardable;

/// Base class that can handle granting rewards to visiting heroes.
/// Inherits from CArmedInstance for proper trasfer of armies
import netpacks.MetaString;

class RewardableObject extends ArmedInstance {
    /// Rewards that can be granted by an object
    private var info:Array<VisitInfo>;

    /// MetaString's that contain text for messages for specific situations
    private var onSelect:MetaString;
    private var onVisited:MetaString;
    private var onEmpty:MetaString;

    /// how reward will be selected, uses SelectMode enum
    private var selectMode:SelectMode;
    /// contols who can visit an object, uses VisitMode enum
    private var visitMode:VisitMode;
    /// reward selected by player
    private var selectedReward:Int;

    /// object visitability info will be reset each resetDuration days
    private var resetDuration:Int;

    /// if true - player can refuse visiting an object (e.g. Tomb)
    private var canRefuse:Bool;

    public function new() {
        super();
    }
}

/// controls selection of reward granted to player
@:enum abstract SelectMode(Int) from Int to Int {
    public var SELECT_FIRST:Int = 0;  // first reward that matches limiters
    public var SELECT_PLAYER:Int = 1; // player can select from all allowed rewards
    public var SELECT_RANDOM:Int = 2;  // reward will be selected from allowed randomly
}

@:enum abstract VisitMode(Int) from Int to Int {
    public var VISIT_UNLIMITED:Int = 0; // any number of times. Side effect - object hover text won't contain visited/not visited text
    public var VISIT_ONCE:Int = 1;      // only once, first to visit get all the rewards
    public var VISIT_HERO:Int = 2;      // every hero can visit object once
    public var VISIT_BONUS:Int = 3;     // can be visited by any hero that don't have bonus from this object
    public var VISIT_PLAYER:Int = 4;     // every player can visit object once
}