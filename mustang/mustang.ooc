import io/File
import structs/ArrayList
import mustang/[Template, YAMLContext]

main: func(args: ArrayList<String>) -> Int {
    if(args size() < 3) {
        "Usage: mustang <TEMPLATE> <YAML>" println()
        return 1
    }

    context := YAMLContext loadFromFile(args[2])
    template := Template loadFromFile(args[1])
    template render(context) println()

    return 0
}
