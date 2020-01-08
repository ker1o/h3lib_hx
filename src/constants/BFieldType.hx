package constants;

//   1. sand/shore   2. sand/mesas   3. dirt/birches   4. dirt/hills   5. dirt/pines   6. grass/hills   7. grass/pines
//8. lava   9. magic plains   10. snow/mountains   11. snow/trees   12. subterranean   13. swamp/trees   14. fiery fields
//15. rock lands   16. magic clouds   17. lucid pools   18. holy ground   19. clover field   20. evil fog
//21. "favorable winds" text on magic plains background   22. cursed ground   23. rough   24. ship to ship   25. ship
@:enum abstract BFieldType(Int) from Int to Int {
    public var NONE:Int = -1;
    public var NONE2:Int = 0;
    public var SAND_SHORE:Int = 1;
    public var SAND_MESAS:Int = 2;
    public var DIRT_BIRCHES:Int = 3;
    public var DIRT_HILLS:Int = 4;
    public var DIRT_PINES:Int = 5;
    public var GRASS_HILLS:Int = 6;
    public var GRASS_PINES:Int = 7;
    public var LAVA:Int = 8;
    public var MAGIC_PLAINS:Int = 9;
    public var SNOW_MOUNTAINS:Int = 10;
    public var SNOW_TREES:Int = 11;
    public var SUBTERRANEAN:Int = 12;
    public var SWAMP_TREES:Int = 13;
    public var FIERY_FIELDS:Int = 14;
    public var ROCKLANDS:Int = 15;
    public var MAGIC_CLOUDS:Int = 16;
    public var LUCID_POOLS:Int = 17;
    public var HOLY_GROUND:Int = 18;
    public var CLOVER_FIELD:Int = 19;
    public var EVIL_FOG:Int = 20;
    public var FAVORABLE_WINDS:Int = 21;
    public var CURSED_GROUND:Int = 22;
    public var ROUGH:Int = 23;
    public var SHIP_TO_SHIP:Int = 24;
    public var SHIP:Int = 25;
}
