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
}

ListValue: class <T> extends Value {
    list: List<T>

    init: func(=list) {}

    type: func -> String { "List" }
    toString: func -> String { "List size=%d" format(list size()) }

    list: func -> List<T> { list }
}

Context: abstract class {
    add: abstract func(name: String, value: Value)
    get: abstract func(name: String, value: Value)

    addString: func(name: String, value: String) {
        add(name, StringValue new(value))
    }

    addBool: func(name: String, value: Bool) {
        add(name, BoolValue new(value))
    }

    addList: func <T> (name: String, value: List<T>) {
        add(name, ListValue<T> new(value))
    }
}

HashContext: class extends Context {
    data: HashMap<Value>

    init: func ~withHashMap(=data) {}
    init: func { data = HashMap<Value> new() }

    add: func(name: String, value: Value) {
        data add(name, value)
    }

    get: func(name: String) -> Value {
        data get(name)
    }
}
