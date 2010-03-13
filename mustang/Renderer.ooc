import io/Writer
import text/Buffer
import mustang/[Node, Walker, Context]


Renderer: class extends NodeWalker {
    rootNode: TNode
    context: Context
    output: Writer

    init: func(=rootNode) {}

    onNode: func(node: TNode) {
        node render(context, output)
    }

    render: func(context: Context, output: Writer) {
        this context = context
        this output = output
        walk(rootNode, false)
    }
    render: func ~toString(context: Context) -> String {
        buffer := Buffer new(1000)
        render(context, BufferWriter new(buffer))
        return buffer toString()
    }
}
