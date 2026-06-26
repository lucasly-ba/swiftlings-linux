// strings2.swift
//
// Multi-line strings and escape sequences make working with text easier.
// Fix the strings to match the expected output.


/// Function that creates various string formats using multi-line strings and escape sequences
func createFormattedStrings() -> (poem: String, quote: String, twoLines: String) {
    let poem = """
        Roses are red,
        Violets are blue,
        Swift is awesome,
        And so are you!
    """

    let quote = "She said, \"Hello!\""

    let twoLines = "First line\nSecond line"

    return (poem, quote, twoLines)
}

func test() {
    let result = createFormattedStrings()

    // Test multi-line string
    let expectedPoem = """
        Roses are red,
        Violets are blue,
        Swift is awesome,
        And so are you!
    """
    assertEqual(result.poem, expectedPoem, "Poem should be a proper multi-line string with triple quotes")

    // Test escape sequences for quotes
    assertEqual(result.quote, "She said, \"Hello!\"", "Quote should include escaped double quotes")

    // Test newline character
    assertEqual(result.twoLines, "First line\nSecond line", "String should contain a newline character")

    // Additional test to ensure the strings contain the expected characters
    assertTrue(result.quote.contains("\""), "Quote string should contain actual quote characters")
    assertTrue(result.twoLines.contains("\n"), "Two lines string should contain a newline character")
}

func main() {
    print(createFormattedStrings().quote)

    test()
    runTests()
}
