import mustang/[Node, TagParser]

import io/[File, FileReader]
import structs/[Stack, List, LinkedList]
import text/Regexp
import text/Buffer


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

    state: Int
    index, currentLine, currentColumn: Int
    buffer: Buffer
    nextChar: Char
    skipChar: Bool

    startTag, endTag: String
    tagRegex: Regexp
    parsers: LinkedList<TagParser>

    firstNode, currentNode: TNode
    nodeStack: Stack<TNode>

    getParserFromFile: static func(file: File) -> This {
        size := file size()
        buffer: String = gc_malloc(size + 1)
        FileReader new(file) read(buffer, 0, size)
        buffer[size] = '\0';
        return new(buffer, "{{", "}}")  //TODO: un-hardcode
    }

    init: func(=templateText, =startTag, =endTag) {
        buffer = Buffer new(1024)
        parsers = LinkedList<TagParser> new()
        nodeStack = Stack<TNode> new()
        tagRegex = Regexp compile("^%s.+%s$" format(startTag, endTag), RegexpOption DOTALL)

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
        state = ParserState PARSE_TEXT
        index = 0; currentLine = 1; currentColumn = 0
        buffer size = 0
        currentNode = null
        skipChar = false

        // Parser state machine
        while(state != ParserState STOP) {
            nextChar = templateText charAt(index)

            if(state == ParserState PARSE_TEXT) state = parseText()
            else if(state == ParserState PARSE_TAG) state = parseTag()
            else Exception new("Invalid parser state: %d" format(state)) throw()

            if(nextChar == '\0') {
                // End of template, stop parsing!
                break
            }
            else if(nextChar == '\n') {
                // Increment line count and reset column
                currentLine += 1
                currentColumn = 0
            }
            else {
                currentColumn += 1
            }

            if(!skipChar) buffer append(nextChar)
            else skipChar = false
            index += 1
        }

        return firstNode
    }

    parseText: func -> Int {
        // If at the start of a tag or end of template,
        // create a new TextNode to store the buffered text.
        if(nextChar == '\0' || templateText compare(startTag, index)) {
            if(buffer size) {
                appendNode(TextNode new(buffer toString() clone()))
                buffer size = 0
            }
            return ParserState PARSE_TAG
        }

        return ParserState PARSE_TEXT
    }

    parseTag: func -> Int {
        if(tagRegex matches(buffer toString())) {
            tag := buffer toString()

            // Strip off start and end mustaches plus whitespace
            tag = tag substring(startTag length(), tag length() - endTag length()) trim()
            buffer size = 0

            if(tag first() == '/') {
                // Block end tag
                endBlock()
                if(nextChar == '\n') {
                    // Skip any newline after the block tag.
                    skipChar = true
                }

                return ParserState PARSE_TEXT
            }
            else {
                // Find a parser for the tag and generate node
                for(p: TagParser in parsers) {
                    if(p matches(tag)) {
                        node := p parse(tag)
                        if(node) {
                            appendNode(node)
                        }

                        if(p isBlock()) {
                            startBlock()
                            if(nextChar == '\n') {
                                // Skip any newlines after a block tag.
                                skipChar = true
                            }
                        }

                        return ParserState PARSE_TEXT
                    }
                }

                Exception new("Invald tag: %s" format(tag)) throw()
            }
        }

        else if(nextChar == '\0') {
            Exception new("Opps, looks like you have an incomplete tag at the end of the file!") throw()
        }

        return ParserState PARSE_TAG
    }
}

ParserState: class {
    STOP: static Int = 1
    PARSE_TEXT: static Int = 2
    START_PARSE_TAG: static Int = 3
    PARSE_TAG: static Int = 4
}
