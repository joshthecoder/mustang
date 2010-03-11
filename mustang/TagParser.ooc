import mustang/Node

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
    parse: abstract func(token: String) -> TNode
}
