package mapping;

import creature.Creature.Resources;

class MapEvent {
    public var name:String;
    public var message:String;
    public var resources:Resources;
    public var players:UInt; // affected players, bit field?
    public var humanAffected:Bool;
    public var computerAffected:UInt;
    public var firstOccurence:UInt;
    public var nextOccurence:UInt; /// specifies after how many days the event will occur the next time; 0 if event occurs only one time

    public function new() {
        resources = new Resources();
    }
}
