package mapObjects.quest;

import mapObjects.hero.GHeroInstance;

interface IQuestObject {
    var quest(default, null):Quest;
    function getVisitText():Void;
    function checkQuest(hero:GHeroInstance):Bool;
}
