import io/Writer
import mustang/[Context, Loader, Parser, Renderer]

Template: class extends Context {
    defaultLoader := static TemplateLoader new()

    templateName: String
    templateLoader: TemplateLoader
    templateRenderer: Renderer

    getRenderer: func -> Renderer {
        if(!templateRenderer) {
            if(!templateName) templateName = class name toLower()
            if(templateLoader) templateRenderer = templateLoader load(templateName)
            else templateRenderer = This defaultLoader load(templateName)
        }

        return templateRenderer
    }

    render: func(out: Writer) {
        getRenderer() render(this, out)
    }

    render: func ~string -> String {
        getRenderer() render(this)
    }
}
