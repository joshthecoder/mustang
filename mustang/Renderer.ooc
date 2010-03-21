import io/Writer
import text/Buffer
import mustang/[Node, Visitor, Context]


Renderer: class extends Visitor {
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
        run(rootNode, false)
    }
    render: func ~toString(context: Context) -> String {
        buffer := Buffer new(1000)
        render(context, BufferWriter new(buffer))
        return buffer toString()
    }
}
