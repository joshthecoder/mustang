import text/Buffer

/**
    Escape < > & " ' characters in the string.
*/
escapeHTML: func(text: String) -> String {
    // Allocate a buffer to hold the escaped string
    // as we build it. Give it some extra space since
    // each escaped char will increase length.
    // Hopefully this will help avoid re-sizes most of the time.
    escaped := Buffer new(text length() + 128)

    for(c: Char in text) {
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
