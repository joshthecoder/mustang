import structs/[LinkedList, HashMap]
import io/File
import mustang/[Parser, Renderer]


/**
    Loads and parsers templates by name returning
    a Renderer instance that can then be used for rendering
    the template. This loader will be used by partial tags.
*/
TemplateLoader: class {
    searchPaths: LinkedList<String>
    cache: HashMap<String, Renderer>

    init: func(=searchPaths) {
        cache = HashMap<String, Renderer> new()
    }
    init: func ~singlePath(searchPath: String) {
        paths := LinkedList<String> new()
        paths add(searchPath)
        this(paths)
    }
    init: func ~useCwd {
        this(File getCwd())
    }

    addPath: func(path: String) {
        searchPaths add(path)
    }

    load: func(name: String) -> Renderer {
        // First check if this template is in our cache
        if(cache contains(name)) return cache get(name)

        // Search paths for a template that matches the name
        renderer: Renderer = null
        for(searchPath: String in searchPaths) {
            fullPath := "%s%c%s" format(searchPath, File separator, name)

            // First try finding file with .mustache extension
            file := File new("%s.%s" format(fullPath, "mustache"))
            if(file exists()) {
                renderer = loadFromFile(file)
            }

            // Try again with .mustang extension
            file = File new("%s.%s" format(fullPath, "mustang"))
            if(file exists()) {
                renderer = loadFromFile(file)
            }
        }

        // Add renderer to cache
        if(renderer) cache put(name, renderer)

        // No template found with that name
        return renderer
    }

    loadFromFile: func(file: File) -> Renderer {
        parser := TemplateParser getParserFromFile(file)
        return Renderer new(parser parse())
    }
}
