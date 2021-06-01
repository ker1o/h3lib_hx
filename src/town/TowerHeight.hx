package town;

@:enum abstract TowerHeight(Int) from Int to Int {
    var HEIGHT_NO_TOWER = 5; // building has not 'lookout tower' ability
    var HEIGHT_LOW = 10;     // low lookout tower, but castle without lookout tower gives radius 5
    var HEIGHT_AVERAGE = 15;
    var HEIGHT_HIGH = 20;    // such tower is in the Tower town
    var HEIGHT_SKYSHIP = 2147483647;  // grail, open entire map
}