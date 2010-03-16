use yaml
import yaml/[Parser, Document]

import io/File
import mustang/[Context, Value]


YAMLContext: class extends Context {
    loadFromString: static func(text: String) -> This {
        parser := YAMLParser new()
        parser setInputString(text)
        This new(parser)
    }

    loadFromFile: static func(file: File) -> This {
        parser := YAMLParser new()
        parser setInputFile(file)
        This new(parser)
    }

    loadFromFile: static func ~path(path: String) -> This {
        This loadFromFile(File new(path))
    }

    init: func(parser: YAMLParser) {
        document := parser parseDocument()
        rootValue := nodeToValue(document getRootNode())
        if(rootValue class != HashValue) {
            Exception new("Root value must be a hash!") throw()
        }

        super(rootValue as HashValue)
    }

    nodeToValue: static func(node: DocumentNode) -> Value {
        match node class {
            case ScalarNode => StringValue new((node as ScalarNode) value)
            case SequenceNode => sequenceToListValue(node as SequenceNode)
            case MappingNode => mappingToHashValue(node as MappingNode)
            case => Exception new("Unknown node type!") throw(); null
        }
    }

    sequenceToListValue: static func(seq: SequenceNode) -> ListValue {
        list := ListValue new()

        for(node: DocumentNode in seq toList()) {
            list appendValue(nodeToValue(node))
        }

        return list
    }

    mappingToHashValue: static func(map: MappingNode) -> HashValue {
        hashes := map toHashMap()
        values := HashValue new()

        for(key: String in hashes getKeys()) {
            value := hashes get(key)
            values setValue(key, nodeToValue(value))
        }

        return values
    }
}
