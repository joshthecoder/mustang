import io/[File, FileReader]
import structs/Stack
import mustang/[Node, Loader]


/**
    Template parser that scans the template and generates an node tree.
*/
TemplateParser: class {
    templateText: String
    partials: TemplateLoader
    openTag, closeTag: String

    marker: Int

    firstNode, currentNode: TNode
    nodeStack: Stack<TNode>

    lastErrorMsg: String
    parseError: Bool

    getParserFromFile: static func ~withPartials(file: File, partials: TemplateLoader) -> This {
        size := file size()
        buffer: String = gc_malloc(size + 1)
        FileReader new(file) read(buffer, 0, size)
        buffer[size] = '\0';
        return new(buffer, partials, "{{", "}}")  //TODO: un-hardcode
    }
    getParserFromFile: static func(file: File) -> This {
        partials := TemplateLoader new(file parentName())
        return This getParserFromFile(file, partials)
    }

    init: func(=templateText, =partials, =openTag, =closeTag) {
        parseError = false
        nodeStack = Stack<TNode> new()
        marker = 0
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
        templateLength := templateText length()
        openTagLength := openTag length()
        closeTagLength := closeTag length()

        while(marker < templateLength) {
            // Find index of next tag
            tagStartIndex := templateText indexOf(openTag, marker)
            if(tagStartIndex == -1) {
                // No more tags, rest is just plain text
                parseText(templateText substring(marker))
                break
            }

            // Push any plain text before the next into a node
            if(marker < tagStartIndex) {
                parseText(templateText substring(marker, tagStartIndex))
            }

            // Index to the start of the tag body
            tagBodyIndex := tagStartIndex + openTagLength

            // Determine what type of tag we are parsing
            tagType := templateText charAt(tagBodyIndex)
            if(!tagType isAlphaNumeric()) {
                // Do not include tag operators in the tag body
                tagBodyIndex += 1
            }

            // Find tag ending index
            tagEndIndex := templateText indexOf(closeTag, tagBodyIndex)

            // Extract the tag body content {{...body...}}
            tagBody := templateText substring(tagBodyIndex, tagEndIndex) trim()

            // Advance marker past end of tag
            marker = tagEndIndex + closeTagLength
            if(tagType == '{') {
                // Be sure to skip past extra } with triplestaches
                marker += 1
            }

            // Parse the tag and generate a node
            node: TNode = match tagType {
                case '#' => parseSectionTag(tagBody)
                case '{' => parseVariableTag(tagBody, false)
                case '&' => parseVariableTag(tagBody, false)
                case '!' => null
                case '/' => parseBlockEndTag()
                case '>' => parsePartialTag(tagBody)
                case => parseVariableTag(tagBody, true)
            }
            if(node) appendNode(node)
        }

        return firstNode
    }

    parseText: func(text: String) {
        appendNode(TextNode new(text))
    }

    parseSectionTag: func(tagBody: String) -> TNode {
        appendNode(SectionNode new(tagBody trim()))
        startBlock()
        if(templateText charAt(marker) == '\n') {
            // Ignore newlines after section tags
            // FIXME: this may causes issue where section tags have text
            // on the same line that comes be for them. In these cases
            // we would probably want to keep the lew line.
            marker += 1
        }
        null
    }

    parseBlockEndTag: func -> TNode {
        endBlock()
        if(templateText charAt(marker) == '\n') {
            // Ignore newlines after section closing tags
            marker += 1
        }
        null
    }

    parsePartialTag: func(tagBody: String) -> TNode {
        renderer := partials load(tagBody)
        if(!renderer) {
            lastErrorMsg = "No partial template found with name '%s'." format(tagBody)
            parseError = true
            return null
        }
        return PartialNode new(renderer)
    }

    parseVariableTag: func(tagBody: String, escape: Bool) -> TNode {
        VariableNode new(tagBody, escape)
    }
}
