import structs/[List, LinkedList]
import mustang/[TemplateReader, Node]

/**
    Used by TemplateParser for parsing tokens.

    Token -> for each TagParser: matches() is true?
    If true: TagParser parse() is called.
*/
TagParser: abstract class {
    /**
        Check if this parser wants to handle this token.
    */
    matches: abstract func(token: String) -> Bool

    /**
        Is this token a single statement or block of statements?
    */
    isBlock: func -> Bool { false }

    /**
        Parse the token text and return a Node.
    */
    parse: abstract func(token: String) -> BaseNode
}


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
    nodes: List<BaseNode>
    startTag, endTag: String
    state: Int

    init: func(=template, =startTag, =endTag) {
        state = 1
    }

    parse: func -> List<BaseNode> {
        nodes = LinkedList<BaseNode> new()

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
            "length: %d" format(template length()) println()
            nodes add(TextNode new(start, template length() - start))
            state = 0 // hault parsing
        }
        else {
            nodes add(TextNode new(start, end - start))
            state = 2 // parse the tag next
        }
    }

    parseTag: func {
        // skip tag opening tokens {{
        template skip(startTag length())

        tag := template readUntil(endTag)
        "Got tag: %s" format(tag) println()
        //TODO: pass into tag parser

        // skip past closing tokens }}
        template skip(endTag length())

        state = 1
    }

    parseBlock: func {
    }
}
