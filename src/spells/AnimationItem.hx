package spells;

//struct
class AnimationItem {
    public var resourceName:String;
    public var verticalPosition:VerticalPosition;
    public var pause:Int;

    public function new() {
    }
}

typedef TAnimation = AnimationItem;
typedef TAnimationQueue = Array<TAnimation>;