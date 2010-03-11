import io/Writer
import mustang/Context

/**
    Base template node interface.
*/
TNode: abstract class {
    next, firstChild: This

    render: abstract func(context: Context, out: Writer)

    debug: abstract func -> String
}

/**
    Represents all the plain text in a template file.
*/
TextNode: class extends TNode {
    text: String

    init: func(=text) {}

    render: func(context: Context, out: Writer) {
        out write(text)
    }

    debug: func -> String { "Text: '%s'" format(text) }
}

VariableNode: class extends TNode {
    variableName: String

    init: func(=variableName) {}

    render: func(context: Context, out: Writer) {
        variable := context resolve(variableName)
        out write(variable toString())
    }

    debug: func -> String { "Variable: name=%s" format(variableName) }
}

SectionNode: class extends TNode {
    name: String

    init: func(=name) {}

    render: func(context: Context, out: Writer) {
    }

    debug: func -> String { "Section: name=%s" format(name) }
}
