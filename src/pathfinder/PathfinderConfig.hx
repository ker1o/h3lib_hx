package pathfinder;

import pathfinder.PathFinderOptions.PathfinderOptions;

class PathfinderConfig {
    public var nodeStorage:INodeStorage;
    public var rules:Array<IPathfindingRule>;
    public var options:PathfinderOptions;

    public function new(nodeStorage:INodeStorage, rules:Array<IPathfindingRule>) {
        this.nodeStorage = nodeStorage;
        this.rules = rules;
    }
}