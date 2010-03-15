import structs/[HashMap, List]


Value: abstract class {
    /**
        Called by nodes to emit the value into the template.
    */
    emit: abstract func -> String
}

StringValue: class extends Value {
    value: String

    init: func(=value) {}

    emit: func -> String { value }
}

BoolValue: class extends Value {
    value: Bool

    init: func(=value) {}

    emit: func -> String { value toString() }

    isTrue: func -> Bool { value }
    isFalse: func -> Bool { !value }
}

ListValue: class extends Value {
    list: List<Value>

    init: func(=list) {}

    emit: func -> String {
        "List(size=%d)" format(list size())
    }

    list: func -> List<Value> { list }
}

HashValue: class extends Value {
    hash: HashMap<Value>

    init: func ~fromHashMap(=hash) {}
    init: func ~empty { this(HashMap<Value> new()) }

    emit: func -> String { "Hash" }

    addValue: func(name: String, value: Value) {
        hash add(name, value)
    }

    getValue: func(name: String) -> Value {
        hash get(name)
    }

    hash: func -> HashMap<Value> { hash }
}
