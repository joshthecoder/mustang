import io/Writer
import structs/[List, HashMap]
import mustang/[Context, Value, Renderer, Template, Escape]

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
    escape: Bool

    init: func(=variableName, =escape) {}

    render: func(context: Context, out: Writer) {
        // Perform variable lookup in context
        variable := context resolve(variableName)
        if(!variable) {
            Exception new("Variable '%s' not found in context!" format(variableName)) throw()
        }

        // Convert variable to text format
        variableText := variable emit()
        if(escape) {
            // Escape any HTML in the text
            variableText = variableText escapeHTML()
        }

        // Write variable text to output stream
        out write(variableText)
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

        if(variable instanceOf(ListValue)) {
            itemContext: Context

            for(item: Value in (variable as ListValue) list()) {
                if(item instanceOf(HashValue)) {
                    itemContext = Context new(item as HashValue)
                }
                else {
                    itemContext = Context new()
                    itemContext setValue("item", item)
                }

                Renderer new(this firstChild) render(itemContext, out)
            }
        }
        else if(variable instanceOf(BoolValue)) {
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

PartialNode: class extends TNode {
    partialTemplate: Template

    init: func(=partialTemplate) {}

    render: func(context: Context, out: Writer) {
        partialTemplate render(context, out)
    }

    debug: func -> String { "Partial" }
}
