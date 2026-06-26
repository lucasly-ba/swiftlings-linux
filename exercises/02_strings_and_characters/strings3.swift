// strings3.swift
//
// Swift strings are not indexed by integers. You move through them with
// String.Index values, built from startIndex using index(after:) and
// index(_:offsetBy:), then read characters with a subscript.
//
// Fix the extraction functions to use String.Index correctly.

/// Return the first character of the string as a String.
func firstCharacter(of text: String) -> String {
    // TODO: A Swift String cannot be subscripted with an Int.
    // Use text.startIndex to read the first character.
    return String(text[0])
}

/// Return the character at a given offset from the start, as a String.
func character(of text: String, at offset: Int) -> String {
    // TODO: Build a String.Index with index(_:offsetBy:) starting from startIndex.
    let position = offset
    return String(text[position])
}

/// Return the substring from `start` up to (but not including) `end`.
func slice(of text: String, from start: Int, to end: Int) -> String {
    // TODO: Turn the integer offsets into String.Index values, then form a range.
    return String(text[start..<end])
}

func test() {
    assertEqual(firstCharacter(of: "Swift"), "S", "first character of Swift is S")
    assertEqual(character(of: "Swift", at: 2), "i", "character at offset 2 is i")
    assertEqual(slice(of: "Swift", from: 1, to: 4), "wif", "slice from 1 to 4 of Swift is wif")
}

func main() {
    test()
    runTests()
}
