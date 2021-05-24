package constants;

@:enum abstract DateType(Int) from Int to Int {
    var DAY = 0;
    var DAY_OF_WEEK = 1;
    var WEEK = 2;
    var MONTH = 3;
    var DAY_OF_MONTH;
}