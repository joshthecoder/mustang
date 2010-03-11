import io/Writer
import text/Buffer
import mustang/[Node, Walker, Context]


Renderer: class extends NodeWalker {
    rootNode: TNode
    context: Context
    output: Writer

    init: func(=rootNode, =context) {}

    onNode: func(node: TNode) {
        node render(context, output)
    }

    render: func(output: Writer) {
        this output = output
        walk(rootNode, false)
    }
    render: func ~toString -> String {
        buffer := Buffer new(1000)
        render(BufferWriter new(buffer))
        return buffer toString()
    }
}
