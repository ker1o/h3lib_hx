package gamestatefwd;

import mapObjects.ArmedInstance;
import constants.id.PlayerColor;

class InfoAboutArmy {
    public var owner:PlayerColor;
    public var name:String;

    public var army:ArmyDescriptor;

    public function new(army:ArmedInstance = null, detailed:Bool = false) {
        if (army != null) {
            initFromArmy(army, detailed);
        }
    }

    public function initFromArmy(army:ArmedInstance, detailed:Bool) {
        this.army = new ArmyDescriptor(army, detailed);
        owner = army.tempOwner;
        name = army.getObjectName();
    }
}