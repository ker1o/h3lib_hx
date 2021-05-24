package pathfinder;

interface IPathfindingRule {
    function process(
        source:PathNodeInfo,
        destination:DestinationNodeInfo,
        pathfinderConfig:PathfinderConfig,
        pathfinderHelper:PathfinderHelper):Void;
}