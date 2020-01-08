package utils.logicalexpression;

class TestVisitor<T> {
    private var _testFunc:T->Bool;

    public function new(testFunc:T->Bool) {
        _testFunc = testFunc;
    }

    public function test(element:Variant<T>):Bool {
        var logicalElement:LogicalElement<T> = element;
        if(logicalElement != null) {
            switch(logicalElement.type) {
                case LogicalElementType.SOME:
                    return countPassed(logicalElement.expressions) > 0;
                case LogicalElementType.NONE:
                    return countPassed(logicalElement.expressions) == 0;
                case LogicalElementType.ALL:
                    return countPassed(logicalElement.expressions) == logicalElement.expressions.length;
            }
        } else {
            var el:T = element;
            if(el != null) {
                return _testFunc(el);
            } else {
                throw 'TestVisitor.test(): what the type of ${element}?';
            }
        }
    }

    private function countPassed(expr:Array<Variant<T>>):Int {
        var count = 0;
        for(element in expr) {
            var logicalElement:LogicalElement<T> = element;
            if(logicalElement != null) {
                count += countPassed(logicalElement.expressions);
            } else {
                var el:T = element;
                if(element != null) {
                    if(_testFunc(el)) {
                        count++;
                    }
                } else {
                    throw 'TestVisitor.countPassed(): what the type of ${element}?';
                }
            }
        }
        return count;
    }
}
