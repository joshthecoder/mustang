import mustang/Node

NodeWalker: abstract class {
    root: TNode
    level: Int

    onNode: abstract func(node: TNode)

    walk: func(root: TNode) {
        level = -1
        visit(root)
    }

    visit: func(node: TNode) {
        level += 1
        c: TNode = node

        while(c) {
            onNode(c)
            if(c firstChild) visit(c firstChild)
            c = c next
        }

        level -= 1
    }
}

NodePrinter: class extends NodeWalker {
    onNode: func(node: TNode) {
        "%s%s" format("--> " times(level), node debug()) println()
    }
}
