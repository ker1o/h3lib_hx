package lib.utils.logicalexpression;

class LogicalExpression<T> {
    private var _data:Variant<T>;

    public function new(data:Variant<T>) {
        _data = data;
    }

    public static function getOperatorAll<T>():LogicalElement<T> {
        return new LogicalElement<T>(LogicalElementType.ALL);
    }

    public static function getOperatorNone<T>():LogicalElement<T> {
        return new LogicalElement<T>(LogicalElementType.NONE);
    }

    public static function getOperatorSome<T>():LogicalElement<T> {
        return new LogicalElement<T>(LogicalElementType.SOME);
    }

    public function test(testFunc:T->Bool) {
        var testVisitor = new TestVisitor<T>(testFunc);
        return testVisitor.test(_data);
    }

    public function morph(morpher:T->Variant<T>):LogicalExpression<T> {
        var forEachVisitor = new ForEachVisitor<T>(morpher);
        forEachVisitor.visit(_data);
        return this;
    }

    public function get():Variant<T> {
        return _data;
    }

    public function toString():String {
        return _data.toString();
    }

}
