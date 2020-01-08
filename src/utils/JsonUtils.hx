package utils;

import herobonus.Bonus;

using Reflect;

class JsonUtils {
    public static function parseBonus(obj:Dynamic):Bonus {
        //ToDo
        return new Bonus();
    }

    public static function parseBonusVector(abilityArr:Array<Dynamic>):Bonus {
        //ToDo
        return new Bonus();
    }

    public static function parseTypedBonusShort(dource:Array<Dynamic>, dest:Bonus):Void {
        //ToDo
    }

    public static function inherit(descendant:Dynamic, base:Dynamic):Void {
        // ToDo: check
        var inheritedNode = Reflect.copy(base);
        for (fieldName in descendant.fields()) {
            merge(inheritedNode, fieldName, descendant.field(fieldName), true);
        }
        swap(descendant, inheritedNode);
    }

    public static function merge(dest:Dynamic, destField:String, source:Dynamic, noOverride:Bool = false):Void {
        if(!dest.hasField(destField) || dest.field(destField) == null) {
            try {
                dest.setField(destField, source);
            }
            catch(e:Dynamic) {
                trace("");
            }
            return;
        }

        if (source == null) {
            dest.deleteField(destField);
            trace("Really???");
        } else if (Std.is(source, Array) || !source.isObject()) {
            // there must be a simple value ar an array
            dest.setField(destField, source);
        } else {
            // there must be an object
//            if(!noOverride && source.flags, "override")) {
//                dest.setField(destField, source);
//            } else {
                //recursively merge all entries from struct
                for(nodeField in source.fields()) {
                    merge(dest.field(destField), nodeField, source.field(nodeField), noOverride);
                }
//            }
        }
    }

    public static function swap(a:Dynamic, b:Dynamic) {
        // currently only a becames b
        var fields = a.fields();
        for (field in fields) {
            a.deleteField(field);
        }

        fields = b.fields();
        for (field in fields) {
            a.setField(field, b.field(field));
        }
    }
}
