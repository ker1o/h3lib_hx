package gamestate;

import constants.id.ObjectInstanceId;
import mapObjects.hero.GHeroInstance;

class CampaignHeroReplacement {
    public var hero:GHeroInstance;
    public var heroPlaceholderId:ObjectInstanceId;

    public function new(hero:GHeroInstance, heroPlaceholderId:ObjectInstanceId) {
        this.hero = hero;
        this.heroPlaceholderId = heroPlaceholderId;
    }
}