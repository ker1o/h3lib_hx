package lib.utils.logicalexpression;

class ForEachVisitor<T> {
    private var _morpher:T->Variant<T>;

    public function new(morpher:T->Variant<T>) {
        _morpher = morpher;
    }

    public function visit(element:Variant<T>):Variant<T> {
        var logicalElement:LogicalElement<T> = element;
        if(logicalElement != null) {
            for(el in logicalElement.expressions) {
                visit(el);
            }
            return logicalElement;
        } else {
            var el:T = element;
            if(el != null) {
                return _morpher(el);
            } else {
                throw 'ForEachVisitor.test(): what the type of ${element}?';
            }
        }
    }
}
