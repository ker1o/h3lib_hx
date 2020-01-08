package lib.utils.logicalexpression;

import haxe.ds.Either;

abstract Variant<T>(Either<LogicalElement<T>, T>) from Either<LogicalElement<T>, T> to Either<LogicalElement<T>, T> {
    @:from inline static function fromA<T>(a:LogicalElement<T>):Variant<T> {
        return Left(a);
    }

    @:from inline static function fromB<T>(b:T):Variant<T> {
        return Right(b);
    }

    @:to inline function toA():Null<LogicalElement<T>> return switch(this) {
        case Left(a): a;
        default: null;
    }

    @:to inline function toB():Null<T> return switch(this) {
        case Right(b): b;
        default: null;
    }

    public function toString():String {
        return switch(this) {
            case Left(a): Std.string(a);
            case Right(b): Std.string(b);
        }
    }
}