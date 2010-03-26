import io/File
import structs/ArrayList
import mustang/[Parser, Renderer, YAMLContext]

main: func(args: ArrayList<String>) -> Int {
    if(args size() < 2) {
        "Usage: mustang <TEMPLATE> [YAML]" println()
        return 1
    }

    templateFile := args[1]
    yamlFile: String
    if(args size() != 3) {
        yamlFile = "%s.yaml" format(templateFile substring(0, templateFile lastIndexOf('.')))
    }
    else {
        yamlFile = args[2]
    }

    parser := TemplateParser getParserFromFile(File new(templateFile))
    rootNode := parser parse()
    if(!rootNode) {
        "[ERROR] %s" format(parser lastErrorMsg) println()
        return 1
    }

    context := YAMLContext loadFromFile(yamlFile)
    Renderer new(rootNode) render(context) println()
    return 0
}
