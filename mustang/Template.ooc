import io/[Writer, File]
import mustang/[Context, TemplateParser, Renderer]

Template: class {
    renderer: Renderer

    loadFromPath: static func(path: String) -> This {
        new(TemplateParser getParserFromFile(File new(path)))
    }

    init: func(parser: TemplateParser) {
        rootNode := parser parse()
        renderer = Renderer new(rootNode)
    }

    render: func(context: Context, out: Writer) {
        renderer render(context, out)
    }

    render: func ~toString(context: Context) -> String {
        renderer render(context)
    }
}
