import text/Buffer

String: cover from Char* {
    /**
        Escape < > & " ' characters in the string.
    */
    escapeHTML: func -> This {
        // Allocate a buffer to hold the escaped string
        // as we build it. Give it some extra space since
        // each escaped char will increase length.
        // Hopefully this will help avoid re-sizes most of the time.
        escaped := Buffer new(this length() + 128)

        for(c: Char in this) {
            e: String = match c {
                case '<' => "&lt;"
                case '>' => "&gt;"
                case '&' => "&amp;"
                case '"' => "&quot;"
                case '\'' => "&apos;"
                case =>
                    escaped append(c)
                    continue
                    "null"
            }
            escaped append(e)
        }

        return escaped toString()
    }
}
