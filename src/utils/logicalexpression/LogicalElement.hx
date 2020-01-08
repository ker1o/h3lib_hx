package utils.logicalexpression;

class LogicalElement<T> {

    public var type(default, null):LogicalElementType;
    public var expressions(default, null):Array<Variant<T>>;

    public function new(type:LogicalElementType, expressions:Array<Variant<T>> = null) {
        this.type = type;
        this.expressions = expressions == null ? [] : expressions;
    }

    public function toString():String {
        return '(${expressions.join(" " + type.toString() + " ")})';
    }
}
