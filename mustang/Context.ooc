import structs/[HashMap, List]
import text/StringTokenizer


Value: abstract class {
    type: abstract func -> Class
    toString: abstract func -> String
}

StringValue: class extends Value {
    value: String

    init: func(=value) {}

    type: func -> Class { String }
    toString: func -> String { value }
}

BoolValue: class extends Value {
    value: Bool

    init: func(=value) {}

    type: func -> Class { Bool }
    toString: func -> String { value toString() }

    isTrue: func -> Bool { value }
}

ListValue: class extends Value {
    list: List<Value>

    init: func(=list) {}

    type: func -> Class { List }
    toString: func -> String { "List size=%d" format(list size()) }

    list: func -> List<Value> { list }
}

HashValue: class extends Value {
    hash: HashMap<Value>

    init: func(=hash) {}

    type: func -> Class { HashMap }
    toString: func -> String { "Hash" }

    hash: func -> HashMap<Value> { hash }
    toContext: func -> Context { Context new(hash) }
}

Context: abstract class {
    new: static func -> This {
        HashContext new()
    }
    new: static func ~fromHashMap(hash: HashMap<Value>) -> This {
        HashContext new(hash)
    }

    addValue: abstract func(name: String, value: Value)
    getValue: abstract func(name: String) -> Value
    getRootValue: abstract func -> HashValue

    addString: func(name: String, value: String) {
        addValue(name, StringValue new(value))
    }

    addBool: func(name: String, value: Bool) {
        addValue(name, BoolValue new(value))
    }

    addList: func(name: String, list: List<Value>) {
        addValue(name, ListValue new(list))
    }

    addHash: func(name: String, hash: HashMap<Value>) {
        addValue(name, HashValue new(hash))
    }

    resolve: func(expression: String) -> Value {
        offset := expression indexOf(' ')

        // If just a simple root hash access, return value quickly
        if(offset == -1) {
            return getValue(expression)
        }

        // For complex, chained accesses, tokenize and resolve each one
        current := getRootValue() hash()
        next: Value
        tokenizer := StringTokenizer new(expression, ' ')
        for(name: String in tokenizer) {
            next = current get(name)
            if(!next || next type() != HashMap) break

            current = (next as HashValue) hash()
        }

        return next
    }
}

HashContext: class extends Context {
    root: HashMap<Value>

    init: func ~withHashMap(=root) {}
    init: func { root = HashMap<Value> new() }

    addValue: func(name: String, value: Value) {
        root add(name, value)
    }

    getValue: func(name: String) -> Value {
        root get(name)
    }

    getRootValue: func -> HashValue { HashValue new(root) }
}
