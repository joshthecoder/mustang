import io/Writer
import mustang/[Context, Renderer]

/**
    Base template node interface.
*/
TNode: abstract class {
    next, firstChild: This

    render: abstract func(context: Context, out: Writer)

    debug: abstract func -> String
}

/**
    Represents all the plain text in a template file.
*/
TextNode: class extends TNode {
    text: String

    init: func(=text) {}

    render: func(context: Context, out: Writer) {
        out write(text)
    }

    debug: func -> String { "Text: '%s'" format(text) }
}

VariableNode: class extends TNode {
    variableName: String

    init: func(=variableName) {}

    render: func(context: Context, out: Writer) {
        variable := context resolve(variableName)
        if(!variable) {
            Exception new("Variable '%s' not found in context!" format(variableName)) throw()
        }

        out write(variable toString())
    }

    debug: func -> String { "Variable: name=%s" format(variableName) }
}

SectionNode: class extends TNode {
    variableName: String

    init: func(=variableName) {}

    render: func(context: Context, out: Writer) {
        variable := context resolve(variableName)
        if(!variable) {
            Exception new("Variable '%s' not found in context!" format(variableName)) throw()
        }

        if(variable type() == "List") {
            itemContext: Context

            for(item: Value in (variable as ListValue) list()) {
                if(item type() == "Hash") {
                    itemContext = (item as HashValue) toContext()
                }
                else {
                    itemContext = Context new()
                    itemContext addValue("item", item)
                }

                Renderer new(this firstChild) render(itemContext, out)
            }
        }
        else if(variable type() == "Bool") {
            if((variable as BoolValue) isTrue()) {
                Renderer new(this firstChild) render(context, out)
            }
        }
        else {
            //TODO: better report this error
            Exception new("Section variable must be either list or bool!") throw()
        }
    }

    debug: func -> String { "Section: name=%s" format(variableName) }
}
