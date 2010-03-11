/**
    Base template node interface.
*/
TNode: abstract class {
    next, firstChild: This

    compile: abstract func
    debug: abstract func -> String
}

/**
    Represents all the plain text in a template file.
*/
TextNode: class extends TNode {
    offset, length: Int

    init: func(=offset, =length) {}

    compile: func {}

    debug: func -> String { "Text: offset=%d length=%d" format(offset, length) }
}

VariableNode: class extends TNode {
    variableName: String

    init: func(=variableName) {}

    compile: func {}

    debug: func -> String { "Variable: name=%s" format(variableName) }
}

SectionNode: class extends TNode {
    name: String

    init: func(=name) {}

    compile: func {}

    debug: func -> String { "Section: name=%s" format(name) }
}
