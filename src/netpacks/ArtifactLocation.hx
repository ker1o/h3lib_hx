package netpacks;

import constants.ArtifactPosition;
import artifacts.ArtifactSet;
import creature.StackInstance;
import herobonus.BonusSystemNode;
import mapObjects.hero.GHeroInstance;
import utils.OneOf;

typedef TArtHolder = OneOf<GHeroInstance, StackInstance>;

class ArtifactLocation {

    public var artHolder:TArtHolder;//TODO: identify holder by id
    public var slot:ArtifactPosition;

    public function new(artHolder:TArtHolder, slot:ArtifactPosition) {
        this.artHolder = artHolder; //we are allowed here to const cast -> change will go through one of our packages... do not abuse!
        this.slot = slot;
    }

    public function getHolderArtSet():ArtifactSet {
        var heroInstance:GHeroInstance = artHolder;
        if (heroInstance != null) {
            return heroInstance.artifactSet;
        }
        var stackInstance:StackInstance = artHolder;
        if (stackInstance != null) {
            return stackInstance.artifactSet;
        }
        throw "Can't find ArtifactSet from holder";
    }

    public function getHolderNode():BonusSystemNode {
        var heroInstance:GHeroInstance = artHolder;
        if (heroInstance != null) {
            return heroInstance.bonusSystemNode;
        }
        var stackInstance:StackInstance = artHolder;
        if (stackInstance != null) {
            return stackInstance;
        }
        throw "Can't find BonusSystemNode from holder";
    }
}
