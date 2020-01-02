package lib.mapObjects.quest;

import lib.mapObjects.hero.GHeroInstance;
import mapping.MapBody;

class GBorderGuard extends GKeys implements IQuestObject {
    public var quest(default, null):Quest;

    public function new() {
        super();

        quest = new Quest();
    }

    override public function afterAddToMap(map:MapBody) {
        map.addNewQuestInstance(quest);
    }

    public function checkQuest(hero:GHeroInstance):Bool {
        return wasMyColorVisited(hero.tempOwner);
    }

    public function getVisitText():Void {
        //ToDo
    }
}
