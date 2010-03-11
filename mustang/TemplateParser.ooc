import structs/[List, LinkedList]
import mustang/[TemplateReader, Node, TagParser]

/**
    Parses the template text and returns a list of token Nodes.

    Template text --> [Parser] --> Nodes
                         ^
                         |
                         ---- register TagParsers

    Parser calls each registered TagParser matches() method.
    The first TagParser to return true will be used to parse
    the token. The returned Node by this TagParser will then be appended
    to the NodeList returned at the end of parsing.
*/
TemplateParser: class {
    template: TemplateReader
    nodes: List<TNode>
    parsers: List<TagParser>
    startTag, endTag: String
    state: Int

    init: func(=template, =startTag, =endTag) {
        parsers = LinkedList<TagParser> new()
        state = 1

        // load builtin parsers
        loadBuiltinParsers(parsers)
    }

    parse: func -> List<TNode> {
        nodes = LinkedList<TNode> new()

        while(state) {
            if(state == 1) parseText()
            else if(state == 2) parseTag()
            else if(state == 3) parseBlock()
            else Exception new("Invalid parsing state!") throw()
        }

        return nodes
    }

    parseText: func {
        start := template index()
        end := template skipUntil(startTag)
        if(end == -1) {
            // No more tags to parse, rest of context is plaintext.
            length := template length() - start
            if(length) {
                nodes add(TextNode new(start, template length() - start))
            }
            state = 0 // hault parsing
        }
        else {
            length := end - start
            if(length) {
                nodes add(TextNode new(start, end - start))
            }
            state = 2 // parse the tag next
        }
    }

    parseTag: func {
        // Read the tag from the template
        template skip(startTag length())            // opening mustaches {{
        tag := template readUntil(endTag)           // tag body
        tag = tag trim()
        template skip(endTag length())              // closing mustaches }}

        //TODO: for now must ignore the block closing tags.
        if(tag first() == '/') {
            state = 1
            return
        }

        // Iterate through parsers and try to find a match
        for(p: TagParser in parsers) {
            // If a match is found, parse the tag and push node
            if(p matches(tag)) {
                node := p parse(tag)
                if(node) nodes add(node)
                state = 1
                return
            }
        }

        // If control reaches here, no parser could be found for this tag.
        // Alert the users of the error.
        "ERROR: invalid tag --> {{%s}}" format(tag) println()
        state = 0
    }

    parseBlock: func {
    }
}
