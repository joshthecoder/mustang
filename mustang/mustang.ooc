import io/File
import structs/ArrayList
import mustang/[TemplateParser, TemplateReader, Walker]

main: func(args: ArrayList<String>) -> Int {
    if(args size() < 2) {
        "Usage: mustang <TEMPLATE>" println()
        return 1
    }

    template := TemplateReader getReaderFromFile(File new(args[1]))
    parser := TemplateParser new(template, "{{", "}}")

    root := parser parse()
    printer := NodePrinter new(root)
    printer walk()

    return 0
}
