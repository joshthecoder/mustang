import structs/[Stack, List, LinkedList]
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
    startTag, endTag: String
    parsers: LinkedList<TagParser>
    firstNode, currentNode: TNode
    nodeStack: Stack<TNode>
    currentBlockName: String
    running: Bool

    init: func(=template, =startTag, =endTag) {
        parsers = LinkedList<TagParser> new()
        nodeStack = Stack<TNode> new()

        // load builtin parsers
        loadBuiltinParsers(parsers)
    }

    appendNode: func(node: TNode) {
        if(currentNode) {
            currentNode next = node
        }
        else {
            firstNode = node
        }
        currentNode = node
    }

    startBlock: func {
        nodeStack push(firstNode) .push(currentNode)
        currentNode = null
    }

    endBlock: func {
        blockNode := nodeStack pop()
        blockNode firstChild = firstNode
        firstNode = nodeStack pop()
        currentNode = blockNode
    }

    parse: func -> TNode {
        running = true

        while(true) {
            if(!parseText()) break
            if(!parseTag()) break
        }

        return firstNode
    }

    parseText: func -> Bool {
        if(!template hasNext()) {
            // End of template, stop parsing
            return false
        }

        start := template index()
        end := template skipUntil(startTag)

        if(end == -1) {
            // No more tags to parse, rest of context is plaintext.
            text := template range(start)
            appendNode(TextNode new(text))
            return false
        }
        else if(end != start) {
            text := template range(start, end)
            appendNode(TextNode new(text))
        }

        return true
    }

    parseTag: func -> Bool {
        // Read the tag from the template
        template skip(startTag length())            // opening mustaches {{
        tag := template readUntil(endTag)           // tag body
        tag = tag trim()
        template skip(endTag length())              // closing mustaches }}

        // End of tag block
        if(tag first() == '/') {
            endBlock()
            return true
        }

        // Iterate through parsers and try to find a match
        for(p: TagParser in parsers) {
            if(p matches(tag)) {
                node := p parse(tag)
                if(node) {
                    appendNode(node)
                    if(p isBlock()) startBlock()
                }
                return true
            }
        }

        // If control reaches here, no parser could be found for this tag.
        // Alert the users of the error.
        "ERROR: invalid tag --> {{%s}}" format(tag) println()
        return false
    }
}
