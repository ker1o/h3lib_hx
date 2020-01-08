package artifacts;

import herobonus.Bonus;

class GrowingArtifact extends Artifact {

    public var bonusesPerLevel:Array<{level:UInt, bonus:Bonus}>; //bonus given each n levels
    public var thresholdBonuses:Array<{level:UInt, bonus:Bonus}>; //after certain level they will be added once

    public function new() {
        super();
    }
}
