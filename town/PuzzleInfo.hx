package lib.town;

class PuzzleInfo {

    public var number:Int; //type of puzzle
    public var x:Int; //position x
    public var y:Int; //position y
    public var whenUncovered:Int; //determines the sequnce of discovering (the lesser it is the sooner puzzle will be discovered)
    public var filename:String; //file with graphic of this puzzle

    public function new() {
    }
}
