package lib.mapping;

import lib.utils.logicalexpression.EventExpression;

class TriggeredEvent {
    /// base condition that must be evaluated
    public var trigger:EventExpression;

    /// string identifier read from config file (e.g. captureKreelah)
    public var identifier:String;

    /// string-description, for use in UI (capture town to win)
    public var description:String;

    /// Message that will be displayed when this event is triggered (You captured town. You won!)
    public var onFulfill:String;

    /// Effect of this event. TODO: refactor into something more flexible
    public var effect:EventEffect;

    public function new() {
        effect = new EventEffect();
    }
}
