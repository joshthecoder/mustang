import io/File
import structs/ArrayList
import mustang/[Template, YAMLContext]

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

    context := YAMLContext loadFromFile(yamlFile)
    template := Template loadFromFile(templateFile)
    template render(context) println()

    return 0
}
