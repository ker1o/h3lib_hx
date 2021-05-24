package pathfinder;

import mapObjects.hero.GHeroInstance;
import gamestate.GameState;
import pathfinder.PathFinderOptions.PathfinderOptions;

interface INodeStorage {
    function getInitialNode():GPathNode;
    function calculateNeighbours():Array<GPathNode>;
    function calculateTeleportations():Array<GPathNode>;
    function commit(destination:DestinationNodeInfo, source:PathNodeInfo):Void;
    function initialize(options:PathfinderOptions, gs:GameState, hero:GHeroInstance):Void;
}