import io/[Writer, File]
import mustang/[Context, TemplateParser, TemplateReader, Renderer]

Template: class {
    renderer: Renderer

    loadFromFile: static func(path: String) -> This {
        This new(TemplateReader getReaderFromFile(File new(path)))
    }

    loadFromString: static func(text: String) -> This {
        This new(TemplateReader new(text))
    }

    init: func(reader: TemplateReader) { this(reader, "{{", "}}") }
    init: func ~customTags(reader: TemplateReader, startTag: String, endTag: String) {
        parser := TemplateParser new(reader, startTag, endTag)
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
