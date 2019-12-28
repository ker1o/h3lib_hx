package lib.town;

import constants.BuildingID;
import constants.id.CreatureId;
import gui.geometries.Point;

// Client-only data. Should be moved away from lib
class ClientInfo {
//icons [fort is present?][build limit reached?] -> index of icon in def files
    public var icons:Array<Array<Int>>;
    public var iconSmall:Array<Array<String>>; /// icon names used during loading
    public var iconLarge:Array<Array<String>>;
    public var tavernVideo:String;
    public var musicTheme:String;
    public var townBackground:String;
    public var guildBackground:String;
    public var guildWindow:String;
    public var buildingsIcons:String;
    public var hallBackground:String;
/// vector[row][column] = list of buildings in this slot
    public var hallSlots:Array<Array<Array<BuildingID>>>;

/// list of town screen structures.
/// NOTE: index in vector is meaningless. Vector used instead of list for a bit faster access
    public var structures:Array<Structure>;

    public var siegePrefix:String;
    public var siegePositions:Array<Point>;
    public var siegeShooter:CreatureId; // shooter creature ID

    public function new() {
        icons = [[], []];
        iconSmall = [[], []];
        iconLarge = [[], []];
        hallSlots = [];
        structures = [];
        siegePositions = [];
    }
}
