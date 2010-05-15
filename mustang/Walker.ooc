import mustang/Node

NodeWalker: abstract class {
    root: TNode
    level: Int
    visitChildren: Bool

    onNode: abstract func(node: TNode)

    walk: func(root: TNode, visitChildren: Bool) {
        level = -1
        this visitChildren = visitChildren

        visit(root)
    }

    visit: func(node: TNode) {
        level += 1
        c: TNode = node

        while(c) {
            onNode(c)
            if(visitChildren && c firstChild) visit(c firstChild)
            c = c next
        }

        level -= 1
    }
}

NodePrinter: class extends NodeWalker {
    rootNode: TNode

    init: func ~printer (=rootNode) {}

    print: func {
        walk(rootNode, true)
    }

    onNode: func(node: TNode) {
        "%s%s" format("--> " times(level), node debug()) println()
    }
}
