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

ContextValue: class extends Value {
    context: Context

    init: func(=context) {}

    type: func -> String { "Context" }
    toString: func -> String { "Context" }

    context: func -> Context { context }
}

Context: abstract class {
    add: abstract func(name: String, value: Value)
    get: abstract func(name: String) -> Value

    addString: func(name: String, value: String) {
        add(name, StringValue new(value))
    }

    addBool: func(name: String, value: Bool) {
        add(name, BoolValue new(value))
    }

    addList: func(name: String, value: List<Value>) {
        add(name, ListValue new(value))
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
