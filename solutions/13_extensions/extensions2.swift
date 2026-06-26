// extensions2.swift
//
// Extensions can add protocol conformance to existing types.
// They can also add initializers and subscripts.
//
// Fix the extensions to make the tests pass.

protocol Describable {
    var description: String { get }
}

extension Int: Describable {
    var description: String {
        return "Integer: \(self)"
    }
}

extension String {
    init(repeating character: Character, count: Int) {
        self = String(Array(repeating: character, count: count))
    }

    subscript(safe index: Int) -> Character? {
        guard index >= 0, index < count else { return nil }
        return self[self.index(startIndex, offsetBy: index)]
    }
}

struct Point {
    var x: Double
    var y: Double
}

extension Point {
    init(value: Double) {
        self.init(x: value, y: value)
    }

    init() {
        self.init(x: 0, y: 0)
    }

    static var origin: Point {
        return Point(x: 0, y: 0)
    }
}

extension Array: Describable where Element: Describable {
    var description: String {
        return "[" + map { $0.description }.joined(separator: ", ") + "]"
    }
}

func main() {
    let stars = String(repeating: "*", count: 5)
    print("stars \(stars), 42 -> \((42 as Describable).description)")

    test("Protocol conformance via extension") {
        let number: Describable = 42
        assertEqual(number.description, "Integer: 42", "Int description")

        let negative: Describable = -10
        assertEqual(negative.description, "Integer: -10", "Negative int description")
    }

    test("Custom initializers") {
        let stars = String(repeating: "*", count: 5)
        assertEqual(stars, "*****", "Repeated character string")

        let empty = String(repeating: "X", count: 0)
        assertEqual(empty, "", "Zero count gives empty string")
    }

    test("Subscripts in extensions") {
        let text = "Hello"
        assertEqual(text[safe: 0], "H", "First character")
        assertEqual(text[safe: 4], "o", "Last character")
        assertNil(text[safe: 5], "Out of bounds returns nil")
        assertNil(text[safe: -1], "Negative index returns nil")
    }

    test("Convenience initializers") {
        let square = Point(value: 5)
        assertEqual(square.x, 5.0, "Square point x")
        assertEqual(square.y, 5.0, "Square point y")

        let origin = Point()
        assertEqual(origin.x, 0.0, "Origin x")
        assertEqual(origin.y, 0.0, "Origin y")

        assertEqual(Point.origin.x, 0.0, "Static origin x")
        assertEqual(Point.origin.y, 0.0, "Static origin y")
    }

    test("Conditional conformance") {
        let numbers: [Int] = [1, 2, 3]
        let array: Describable = numbers
        assertEqual(array.description, "[Integer: 1, Integer: 2, Integer: 3]",
                   "Array of describables")
    }

    runTests()
}
