import io/[File, FileReader]

TemplateReader: class {
    content: String
    index: Int

    getReaderFromFile: static func(file: File) -> This {
        size := file size()
        buffer: String = gc_malloc(size + 1)
        FileReader new(file) read(buffer, 0, size)
        buffer[size] = '\0';
        return new(buffer)
    }

    init: func(=content) {
        index = 0
    }

    peek: func -> Char {
        content[index]
    }

    hasNext: func -> Bool {
        return index < content length()
    }

    read: func ~char -> Char {
        c := content[index]
        index += 1
        return c
    }

    index: func -> Int { index }

    length: func -> Int { content length() }

    /**
        Skips ahead until the given pattern is found.

        :pattern: the pattern to stop at
        :return: the new index
    */
    skipUntil: func(pattern: String) -> Int {
        index = content indexOf(pattern, index)
        return index
    }

    readUntil: func(pattern: String) -> String {
        end := content indexOf(pattern, index)
        s := content substring(index, end)
        index = end
        return s
    }

    skip: func(length: Int) { index += length }
}
