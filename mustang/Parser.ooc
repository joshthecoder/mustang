use mustang
import mustang/Node

Parser: abstract class {
    /**
        Check if the given token should be handled by this parser.

        :return: true if this parser should handle this token
    */
    matches: abstract func(token: String) -> Bool

    /**
        Is this token a block or single statement?

        :return: true if token is a block
    */
    isBlock: func -> Bool { false }

    /**
        Parse the token and generate a token Node object.

        :return: the token Node used for compiling
    */
    parse: abstract func(token: String) -> Node
}
