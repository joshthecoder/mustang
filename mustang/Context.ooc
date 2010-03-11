import structs/[HashMap, List]

Value: abstract class {
    typeName: abstract func -> String
    toString: abstract func -> String
}

StringValue: class extends Value {
    value: String

    init: func(=value) {}

    typeName: func -> String { "String" }

    toString: func -> String { value }
}

ListValue: class <T> extends Value {
    list: List<T>

    init: func(=list) {}

    typeName: func -> String { "List" }
    toString: func -> String { "List size=%d" format(list size()) }

    list: func -> List<T> { list }
}

Context: abstract class {
    resolve: abstract func(name: String) -> Value
}

MockContext: class extends Context {
    data: HashMap<Value>

    init: func(=data) {}

    resolve: func(name: String) -> Value {
        data[name]
    }
}
