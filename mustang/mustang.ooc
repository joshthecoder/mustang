import io/File
import structs/ArrayList
import mustang/[TemplateParser, TemplateReader]

main: func(args: ArrayList<String>) -> Int {
    if(args size() < 2) {
        "Usage: mustang <TEMPLATE>" println()
        return 1
    }

    template := TemplateReader getReaderFromFile(File new(args[1]))
    parser := TemplateParser new(template, "{{", "}}")

    parser parse()
    return 0
}
