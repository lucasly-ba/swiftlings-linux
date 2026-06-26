// strings3.swift
//
// Swift strings are not indexed by integers. You move through them with
// String.Index values, built from startIndex using index(after:) and
// index(_:offsetBy:), then read characters with a subscript.
//
// Fix the extraction functions to use String.Index correctly.

/// Return the first character of the string as a String.
func firstCharacter(of text: String) -> String {
    return String(text[text.startIndex])
}

/// Return the character at a given offset from the start, as a String.
func character(of text: String, at offset: Int) -> String {
    let position = text.index(text.startIndex, offsetBy: offset)
    return String(text[position])
}

/// Return the substring from `start` up to (but not including) `end`.
func slice(of text: String, from start: Int, to end: Int) -> String {
    let startIndex = text.index(text.startIndex, offsetBy: start)
    let endIndex = text.index(text.startIndex, offsetBy: end)
    return String(text[startIndex..<endIndex])
}

func test() {
    assertEqual(firstCharacter(of: "Swift"), "S", "first character of Swift is S")
    assertEqual(character(of: "Swift", at: 2), "i", "character at offset 2 is i")
    assertEqual(slice(of: "Swift", from: 1, to: 4), "wif", "slice from 1 to 4 of Swift is wif")
}

func main() {
    print("first \(firstCharacter(of: "Swift")), at 2 \(character(of: "Swift", at: 2)), slice \(slice(of: "Swift", from: 1, to: 4))")

    test()
    runTests()
}
