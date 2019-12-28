package lib.town;

import utils.Int3;

/// This is structure used only by client
/// Consists of all gui-related data about town structures
/// Should be moved from lib to client
class Structure {
    public var building:Building;  // base building. If null - this structure will be always present on screen
    public var buildable:Building; // building that will be used to determine built building and visible cost. Usually same as "building"

    public var pos:Int3;
    public var defName:String;
    public var borderName:String;
    public var areaName:String;
    public var identifier:String;

    public var hiddenUpgrade:Bool; // used only if "building" is upgrade, if true - structure on town screen will behave exactly like parent (mouse clicks, hover texts, etc)

    public function new() {
        pos = new Int3();
   }
}
