package mapObjects;

import constants.ArtifactId;
import constants.SpellId;
import creature.StackBasicDescriptor;
import res.ResourceSet;

class BankConfig {
    public var value:Int; //overall value of given things
    public var chance:Int; //chance for this level being chosen
    public var upgradeChance:Int; //chance for creatures to be in upgraded versions
    public var combatValue:Int; //how hard are guards of this level
    public var guards:Array<StackBasicDescriptor>; //creature ID, amount
    public var resources:ResourceSet; //resources given in case of victory
    public var creatures:Array<StackBasicDescriptor>; //creatures granted in case of victory (creature ID, amount)
    public var artifacts:Array<ArtifactId>; //artifacts given in case of victory
    public var spells:Array<SpellId>; // granted spell(s), for Pyramid
    
    public function new() {
    }
}
