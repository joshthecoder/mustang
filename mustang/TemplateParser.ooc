import mustang/[Node, TagParser]

import io/[File, FileReader]
import structs/[Stack, List, LinkedList]


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
    templateText: String
    index: Int

    startTag, endTag: String
    parsers: LinkedList<TagParser>

    firstNode, currentNode: TNode
    nodeStack: Stack<TNode>
    running: Bool

    getParserFromFile: static func(file: File) -> This {
        size := file size()
        buffer: String = gc_malloc(size + 1)
        FileReader new(file) read(buffer, 0, size)
        buffer[size] = '\0';
        return new(buffer, "{{", "}}")  //TODO: un-hardcode
    }

    init: func(=templateText, =startTag, =endTag) {
        index = 0
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
        if(index >= templateText length()) {
            // End of template, stop parsing
            return false
        }

        // Find the start of the next tag
        indexOfNextTag := templateText indexOf(startTag, index)

        if(indexOfNextTag == -1) {
            // No more tags to parse, rest of context is plaintext.
            text := templateText substring(index)
            appendNode(TextNode new(text))
            return false
        }
        else if(indexOfNextTag != index) {
            text := templateText substring(index, indexOfNextTag)
            appendNode(TextNode new(text))
        }

        index = indexOfNextTag

        return true
    }

    parseTag: func -> Bool {
        // Read the tag from the template
        //TODO: probably best we do this in a regex.
        // as of now triple mustaches don't parse right.
        index += startTag length()  // skip open tag
        indexOfEndTag := templateText indexOf(endTag, index)  // get index of end tag
        tag := templateText substring(index, indexOfEndTag) trim()  // substring out the tag content
        index = indexOfEndTag + endTag length()  // advance past end tag

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
