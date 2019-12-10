package lib.spells;

import lib.spells.Spell.ProjectileInfo;
import lib.spells.AnimationItem.TAnimationQueue;

class AnimationInfo {
    ///displayed on all affected targets.
    public var affect:TAnimationQueue;

    ///displayed on caster.
    public var casting:TAnimationQueue;

    ///displayed on target hex. If spell was cast with no target selection displayed on entire battlefield (f.e. ARMAGEDDON)
    public var hit:TAnimationQueue;

    ///displayed "between" caster and (first) target. Ignored if spell was cast with no target selection.
    ///use selectProjectile to access
    public var projectile:Array<ProjectileInfo>;

    public function new() {
        affect = new TAnimationQueue();
        casting = new TAnimationQueue();
        hit = new TAnimationQueue();
        projectile = [];
    }
}
