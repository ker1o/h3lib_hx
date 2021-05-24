package constants;

@:enum abstract BuildingState(Int) from Int to Int {
    var HAVE_CAPITAL;
    var NO_WATER;
    var FORBIDDEN;
    var ADD_MAGES_GUILD;
    var ALREADY_PRESENT;
    var CANT_BUILD_TODAY;
    var NO_RESOURCES;
    var ALLOWED;
    var PREREQUIRES;
    var MISSING_BASE;
    var BUILDING_ERROR;
    var TOWN_NOT_OWNED;
}