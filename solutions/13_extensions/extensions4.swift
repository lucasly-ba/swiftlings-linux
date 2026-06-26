// extensions4.swift
//
// Extensions can be used to organize code and add functionality
// to generic types with constraints.
//
// Fix the extensions to make the tests pass.

// Base types for testing
struct User {
    let id: Int
    let name: String
    let email: String
}

struct Product {
    let id: Int
    let name: String
    let price: Double
}

struct Cache<Key: Hashable, Value> {
    private var storage: [Key: Value] = [:]

    mutating func set(_ value: Value, for key: Key) {
        storage[key] = value
    }

    func get(_ key: Key) -> Value? {
        return storage[key]
    }
}

extension Cache where Value: Numeric {
    func sum() -> Value {
        return storage.values.reduce(0) { $0 + $1 }
    }
}

extension Cache where Key == String {
    var allKeys: String {
        return storage.keys.sorted().joined(separator: ", ")
    }
}

extension Optional {
    func orThrow(_ error: Error) throws -> Wrapped {
        switch self {
        case .some(let value):
            return value
        case .none:
            throw error
        }
    }

    var isNil: Bool {
        return self == nil
    }
}

protocol Priceable {
    var price: Double { get }
}

extension Product: Priceable {}

extension Array where Element: Priceable {
    var totalPrice: Double {
        return reduce(0) { $0 + $1.price }
    }

    func filterByPrice(max: Double) -> [Element] {
        return filter { $0.price <= max }
    }
}

enum CustomError: Error {
    case noValue
}

func main() {
    var numberCache = Cache<String, Int>()
    numberCache.set(10, for: "a")
    numberCache.set(20, for: "b")
    print("cache sum \(numberCache.sum()), keys \(numberCache.allKeys)")

    test("Generic cache with numeric values") {
        var numberCache = Cache<String, Int>()
        numberCache.set(10, for: "a")
        numberCache.set(20, for: "b")
        numberCache.set(30, for: "c")

        assertEqual(numberCache.sum(), 60, "Sum of cached integers")
    }

    test("Generic cache with string keys") {
        var cache = Cache<String, User>()
        cache.set(User(id: 1, name: "Alice", email: "alice@example.com"), for: "user1")
        cache.set(User(id: 2, name: "Bob", email: "bob@example.com"), for: "user2")

        assertEqual(cache.allKeys, "user1, user2", "All keys joined")
    }

    test("Optional extensions") {
        let value: Int? = 42
        let nilValue: Int? = nil

        do {
            let unwrapped = try value.orThrow(CustomError.noValue)
            assertEqual(unwrapped, 42, "Unwrapped value")
        } catch {
            assertFalse(true, "Should not throw for non-nil")
        }

        do {
            _ = try nilValue.orThrow(CustomError.noValue)
            assertFalse(true, "Should throw for nil")
        } catch CustomError.noValue {
            assertTrue(true, "Threw correct error")
        } catch {
            assertFalse(true, "Wrong error type")
        }

        assertFalse(value.isNil, "Non-nil value")
        assertTrue(nilValue.isNil, "Nil value")
    }

    test("Array extensions with protocol constraints") {
        let products = [
            Product(id: 1, name: "Book", price: 19.99),
            Product(id: 2, name: "Pen", price: 2.99),
            Product(id: 3, name: "Laptop", price: 999.99)
        ]

        assertEqual(products.totalPrice, 1022.97, accuracy: 0.01, "Total price")

        let affordable = products.filterByPrice(max: 20.0)
        assertEqual(affordable.count, 2, "Two affordable products")
        assertEqual(affordable[0].name, "Book", "Book is affordable")
        assertEqual(affordable[1].name, "Pen", "Pen is affordable")
    }

    runTests()
}

/// Helper for comparing doubles with accuracy
func assertEqual(_ actual: Double, _ expected: Double, accuracy: Double, _ message: String) {
    assertTrue(abs(actual - expected) < accuracy,
               "\(message): expected \(expected), got \(actual)")
}
