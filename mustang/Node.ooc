/**
    Base template node interface.
*/
TNode: abstract class {
    compile: abstract func
}

/**
    Represents all the plain text in a template file.
*/
TextNode: class extends TNode {
    offset, length: Int

    init: func(=offset, =length) {
        "Got text at %d length %d" format(offset, length) println()
    }

    compile: func {}
}
