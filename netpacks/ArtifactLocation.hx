package lib.netpacks;

import lib.constants.ArtifactPosition;
import lib.artifacts.ArtifactSet;
import lib.creature.StackInstance;
import lib.herobonus.BonusSystemNode;
import lib.mapObjects.hero.GHeroInstance;
import lib.utils.OneOf;

typedef TArtHolder = OneOf<GHeroInstance, StackInstance>;

class ArtifactLocation {

    public var artHolder:TArtHolder;//TODO: identify holder by id
    public var slot:ArtifactPosition;

    public function new(artHolder:TArtHolder, slot:ArtifactPosition) {
        this.artHolder = artHolder; //we are allowed here to const cast -> change will go through one of our packages... do not abuse!
        this.slot = slot;
    }

    public function getHolderArtSet():ArtifactSet {
        throw "Please finish implement me!";
    }

    public function getHolderNode():BonusSystemNode {
        throw "Please finish implement me!";
    }
}
