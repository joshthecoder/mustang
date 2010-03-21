import mustang/[Node, Visitor]


Compiler: abstract class extends Visitor {
    code: Writer

    getCompilerByName: static func -> This {
    }

    onNode: func(node: TNode) {
        if(node class == TextNode) onTextNode(node)
        else if(node class == VariableNode) onVariableNode(node)
        else if(node class == SectionNode) onSectionNode(node)
        else if(node class == PartialNode) onPartialNode(node)
        else onUnknownNode(node)
    }

    onTextNode: abstract func(node: TextNode)
    onVariableNode: abstract func(node: VariableNode)
    onSectionNode: abstract func(node: SectionNode)
    onPartialNode: abstract func(node: PartialNode)
    onUnknownNode: abstract func(node: UnknownNode)

    setup: abstract func(templateName: String)
    finalize: abstract func

    compile: func(templateName: String, root: TNode, code: Writer) {
        this code = code
        setup(templateName)
        run(root, false)
    }
}
