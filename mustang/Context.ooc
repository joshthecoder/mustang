import structs/[HashMap, List]


Value: abstract class {
    type: abstract func -> String
    toString: abstract func -> String
}

StringValue: class extends Value {
    value: String

    init: func(=value) {}

    type: func -> String { "String" }
    toString: func -> String { value }
}

BoolValue: class extends Value {
    value: Bool

    init: func(=value) {}

    type: func -> String { "Bool" }
    toString: func -> String { value toString() }

    isTrue: func -> Bool { value }
}

ListValue: class extends Value {
    list: List<Value>

    init: func(=list) {}

    type: func -> String { "List" }
    toString: func -> String { "List size=%d" format(list size()) }

    list: func -> List<Value> { list }
}

HashValue: class extends Value {
    hash: HashMap<Value>

    init: func(=hash) {}

    type: func -> String { "Hash" }
    toString: func -> String { "Hash" }

    hash: func -> HashMap<Value> { hash }
    toContext: func -> Context { Context new(hash) }
}

Context: class {
    root: HashMap<Value>

    init: func ~withHashMap(=root) {}
    init: func { root = HashMap<Value> new() }

    addValue: func(name: String, value: Value) {
        root add(name, value)
    }

    addString: func(name: String, value: String) {
        root add(name, StringValue new(value))
    }

    addBool: func(name: String, value: Bool) {
        root add(name, BoolValue new(value))
    }

    addList: func(name: String, list: List<Value>) {
        root add(name, ListValue new(list))
    }

    addHash: func(name: String, hash: HashMap<Value>) {
        root add(name, HashValue new(hash))
    }

    resolve: func(expression: String) -> Value {
    }
}
