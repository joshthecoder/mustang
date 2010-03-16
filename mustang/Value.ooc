import structs/[HashMap, List, LinkedList]


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

    init: func ~withList(=list) {}
    init: func ~empty { list = LinkedList<Value> new() }

    emit: func -> String {
        "List(size=%d)" format(list size())
    }

    appendValue: func(value: Value) {
        list add(value)
    }

    appendString: func(value: String) {
        list add(StringValue new(value))
    }

    appendBool: func(value: Bool) {
        list add(BoolValue new(value))
    }

    appendList: func(list: List<Value>) {
        list add(ListValue new(list))
    }

    appendHashMap: func(hash: HashMap<Value>) {
        list add(HashValue new(hash))
    }

    list: func -> List<Value> { list }
}

HashValue: class extends Value {
    hash: HashMap<Value>

    init: func ~fromHashMap(=hash) {}
    init: func ~empty { this(HashMap<Value> new()) }

    emit: func -> String { "Hash" }

    setValue: func(name: String, value: Value) {
        hash add(name, value)
    }

    setString: func(name: String, value: String) {
        setValue(name, StringValue new(value))
    }

    setBool: func(name: String, value: Bool) {
        setValue(name, BoolValue new(value))
    }

    setList: func(name: String, list: List<Value>) {
        setValue(name, ListValue new(list))
    }

    setHashMap: func(name: String, hash: HashMap<Value>) {
        setValue(name, HashValue new(hash))
    }

    getValue: func(name: String) -> Value {
        hash get(name)
    }

    hash: func -> HashMap<Value> { hash }
}
