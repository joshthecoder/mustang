import structs/List
import mustang/Node

/**
    Used by TemplateParser for parsing tags.

    Token -> for each TagParser: matches() is true?
    If true: TagParser parse() is called.
*/
TagParser: abstract class {
    /**
        Check if this parser wants to handle this tag.
    */
    matches: abstract func(tag: String) -> Bool

    /**
        Is this token a single statement or block of statements?
    */
    isBlock: func -> Bool { false }

    /**
        Parse the tag text and return a Node.
    */
    parse: abstract func(tag: String) -> TNode
}

/**
    Variable tag parser.

    Syntax: {{variableName}}
*/
VariableParser: class extends TagParser {
    matches: func(tag: String) -> Bool { tag first() isAlphaNumeric() }

    parse: func(tag: String) -> TNode {
        "Parsing variable tag: %s" format(tag) println()
        null
    }
}

/**
    Comment tag parser.

    Syntax: {{! do not display me }}
*/
CommentParser: class extends TagParser {
    matches: func(tag: String) -> Bool { tag first() == '!' }

    parse: func(tag: String) -> TNode {
        "Comment: %s" format(tag) println()
        null
    }
}

/**
    Section tag parser.

    Syntax: {{#stuff}} ... {{/stuff}}
*/
SectionParser: class extends TagParser {
    matches: func(tag: String) -> Bool { tag first() == '#' }

    isBlock: func -> Bool { true }

    parse: func(tag: String) -> TNode {
        "Section: %s" format(tag) println()
        null
    }
}

loadBuiltinParsers: func(parsers: List<TagParser>) {
    parsers add(VariableParser new()) .add(CommentParser new()) .add(SectionParser new())
}
