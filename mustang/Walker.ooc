import mustang/Node

NodeWalker: abstract class {
    root: TNode
    level: Int

    init: func(=root) { level = -1 }

    onNode: abstract func(node: TNode)

    walk: func {
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
    // Need to wrap the super init here, otherwise jooc messes up!
    init: func ~printer(.root) { super(root) }

    onNode: func(node: TNode) {
        "%s%s" format("--> " times(level), node debug()) println()
    }
}
