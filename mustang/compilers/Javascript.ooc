import mustang/Compiler


JavascriptCompiler: class extends Compiler {
    setup: func(templateName: String) {
        code write("function render%s(context) {" format(templateName)).
             write("var buffer = Array new();")
    }

    finalize: func {
        code write("};")
    }

    onTextNode: func(node: TextNode) {
        code write("buffer.push(%s);" format(node text))
    }

    onVariableNode: func(node: VariableNode) {
        code write("var value = context.%s;" format(node variableName)).
             write("escape(value);").
             write("buffer.push(value)")
    }

    onSectionNode: func(node: SectionNode) {
    }

    onPartialNode: func(node: PartialNode) {
    }

    onUnknownNode: func(node: UnknownNode) {
    }
}
