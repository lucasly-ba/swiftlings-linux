# Strings and Characters

This section covers Swift's `String` and `Character` types. Swift strings are
Unicode-correct, which makes them a little different from strings in many other
languages: you index them with `String.Index`, not integers.

## Official Swift Documentation
- [Strings and Characters - The Swift Programming Language](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/stringsandcharacters)
- [String - Swift Standard Library](https://developer.apple.com/documentation/swift/string)
- [Character - Swift Standard Library](https://developer.apple.com/documentation/swift/character)

In this section, you'll learn about:
- String interpolation and concatenation
- Multi-line strings and escape sequences
- `String.Index`, `index(after:)`, and `index(_:offsetBy:)`
- Iterating over characters, and helpers like `split`, `contains`, and `replacingOccurrences`

## Key Concepts

### String.Index
A Swift `String` is a collection of `Character` values that may not be the same
size in memory, so you cannot subscript it with an `Int`. Use `startIndex`,
`endIndex`, and `index(_:offsetBy:)` to build the position you want.

### Characters
Iterating a string with `for character in text` gives you one `Character` at a
time, which is handy for counting or inspecting content.

## Further Information

- [Strings and Characters](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/stringsandcharacters)
- [Working with Characters](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/stringsandcharacters#Working-with-Characters)
- [Accessing and Modifying a String](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/stringsandcharacters#Accessing-and-Modifying-a-String)
