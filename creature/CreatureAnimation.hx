package lib.creature;

class CreatureAnimation {
    public var timeBetweenFidgets:Float;
    public var idleAnimationTime;
    public var walkAnimationTime;
    public var attackAnimationTime;
    public var flightAnimationDistance;
    public var upperRightMissleOffsetX:Int;
    public var rightMissleOffsetX:Int;
    public var lowerRightMissleOffsetX:Int;
    public var upperRightMissleOffsetY:Int;
    public var rightMissleOffsetY:Int;
    public var lowerRightMissleOffsetY:Int;

    public var missleFrameAngles:Array<Float>;
    public var troopCountLocationOffset:Int;
    public var attackClimaxFrame:Int;

    public var projectileImageName:String;

    public function new() {
    }
}
