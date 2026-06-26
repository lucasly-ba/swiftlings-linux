// extensions3.swift
//
// Extensions can add nested types and can be constrained with where clauses.
// Protocol extensions can provide default implementations.
//
// Fix the extensions to make the tests pass.

protocol Numeric {
    static func +(lhs: Self, rhs: Self) -> Self
    static func -(lhs: Self, rhs: Self) -> Self
    static func *(lhs: Self, rhs: Self) -> Self
}

extension Int: Numeric {}
extension Double: Numeric {}

extension Array where Element: Numeric {
    func sum() -> Element {
        return dropFirst().reduce(first!) { $0 + $1 }
    }

    func product() -> Element? {
        guard let first = first else { return nil }
        return dropFirst().reduce(first) { $0 * $1 }
    }
}

extension String {
    enum ValidationError: Error {
        case empty
        case tooShort(minimum: Int)
        case invalid
    }

    func validateEmail() throws {
        if isEmpty {
            throw ValidationError.empty
        }
        guard let atIndex = firstIndex(of: "@") else {
            throw ValidationError.invalid
        }
        let afterAt = self[index(after: atIndex)...]
        guard afterAt.contains(".") else {
            throw ValidationError.invalid
        }
    }
}

protocol Resettable {
    mutating func reset()
}

extension Resettable {
    mutating func reset() {
        // Default implementation does nothing.
    }
}

struct Counter: Resettable {
    var value = 0

    mutating func reset() {
        value = 0
    }
}

struct Configuration: Resettable {
    var settings: [String: Any] = ["theme": "dark"]

    mutating func reset() {
        settings = [:]
    }
}

protocol Identifiable {
    var id: String { get }
}

extension Identifiable {
    static func randomID() -> String {
        return "ID-\(Int.random(in: 10000...99999))"
    }
}

func main() {
    print("sum \([1, 2, 3, 4, 5].sum()), product \([2, 3, 4].product() ?? 0)")

    test("Constrained array extensions") {
        assertEqual([1, 2, 3, 4, 5].sum(), 15, "Sum of integers")
        assertEqual([1.5, 2.5, 3.0].sum(), 7.0, "Sum of doubles")

        assertEqual([2, 3, 4].product(), 24, "Product of integers")
        assertEqual([1.5, 2.0].product(), 3.0, "Product of doubles")
        assertNil([Int]().product(), "Empty array product is nil")
    }

    test("Nested types in extensions") {
        do {
            try "test@example.com".validateEmail()
            assertTrue(true, "Valid email passes")
        } catch {
            assertFalse(true, "Valid email should not throw")
        }

        do {
            try "".validateEmail()
            assertFalse(true, "Empty email should throw")
        } catch String.ValidationError.empty {
            assertTrue(true, "Caught empty error")
        } catch {
            assertFalse(true, "Wrong error type")
        }

        do {
            try "notanemail".validateEmail()
            assertFalse(true, "Invalid email should throw")
        } catch String.ValidationError.invalid {
            assertTrue(true, "Caught invalid error")
        } catch {
            assertFalse(true, "Wrong error type")
        }
    }

    test("Protocol extension defaults") {
        var counter = Counter()
        counter.value = 10
        counter.reset()
        assertEqual(counter.value, 0, "Counter resets to 0")

        var config = Configuration()
        config.reset()
        assertTrue(config.settings.isEmpty, "Config resets to empty")
    }

    test("Static methods in protocol extensions") {
        struct User: Identifiable {
            let id: String
        }

        let randomID = User.randomID()
        assertTrue(randomID.hasPrefix("ID-"), "Random ID has prefix")
        assertTrue(randomID.count > 3, "Random ID has content")
    }

    runTests()
}
