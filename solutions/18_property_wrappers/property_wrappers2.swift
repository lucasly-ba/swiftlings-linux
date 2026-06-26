// property_wrappers2.swift
//
// Advanced property wrapper features including composition and custom projections.
// Property wrappers can be composed and work with different types.
//
// Fix the advanced property wrapper features to make the tests pass.

import Foundation

// A thread-safe wrapper. It is a class so all copies of the enclosing value
// share one locked storage, and it exposes a locked read-modify-write.
@propertyWrapper
final class Atomic<Value> {
    private var value: Value
    private let lock = NSLock()

    init(wrappedValue: Value) {
        self.value = wrappedValue
    }

    var wrappedValue: Value {
        get { lock.lock(); defer { lock.unlock() }; return value }
        set { lock.lock(); defer { lock.unlock() }; value = newValue }
    }

    var projectedValue: Atomic<Value> { self }

    func mutate(_ transform: (inout Value) -> Void) {
        lock.lock()
        defer { lock.unlock() }
        transform(&value)
    }
}

@propertyWrapper
struct Clamped {
    private var value: Int
    private let range: ClosedRange<Int>

    init(wrappedValue: Int, _ range: ClosedRange<Int>) {
        self.range = range
        self.value = min(max(wrappedValue, range.lowerBound), range.upperBound)
    }

    var wrappedValue: Int {
        get { value }
        set { value = min(max(newValue, range.lowerBound), range.upperBound) }
    }
}

@propertyWrapper
struct CopyOnWrite<Value> {
    private final class Box {
        var value: Value
        init(_ value: Value) { self.value = value }
    }

    private var box: Box
    private(set) var lastWriteCopied = false

    init(wrappedValue: Value) {
        box = Box(wrappedValue)
    }

    var wrappedValue: Value {
        get { box.value }
        set {
            if isKnownUniquelyReferenced(&box) {
                box.value = newValue
                lastWriteCopied = false
            } else {
                box = Box(newValue)
                lastWriteCopied = true
            }
        }
    }

    var projectedValue: Bool { lastWriteCopied }
}

@propertyWrapper
struct Trimmed {
    private var value: String?

    init(wrappedValue: String?) {
        self.value = wrappedValue?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var wrappedValue: String? {
        get { value }
        set { value = newValue?.trimmingCharacters(in: .whitespacesAndNewlines) }
    }
}

@propertyWrapper
struct Logged<Value> {
    private var value: Value
    private let key: String

    init(wrappedValue: Value, key: String) {
        self.value = wrappedValue
        self.key = key
        print("[\(key)] Initial value: \(value)")
    }

    var wrappedValue: Value {
        get {
            print("[\(key)] Get: \(value)")
            return value
        }
        set {
            print("[\(key)] Set: \(newValue)")
            value = newValue
        }
    }
}

struct DataModel {
    @Atomic var counter: Int = 0

    @CopyOnWrite var largeData: [Int] = []

    @Trimmed var input: String?

    @Logged(key: "important")
    @Clamped(0...100)
    var percentage: Int = 50
}

@propertyWrapper
struct Lazy<Value> {
    private var storage: Value?
    private let initializer: () -> Value

    init(wrappedValue: @autoclosure @escaping () -> Value) {
        self.initializer = wrappedValue
    }

    var wrappedValue: Value {
        mutating get {
            if let storage = storage {
                return storage
            }
            let value = initializer()
            storage = value
            return value
        }
    }

    var projectedValue: Bool { storage != nil }
}

func main() {
    print("property_wrappers2: composition and projections")

    test("Thread-safe property wrapper") {
        var model = DataModel()
        let queue = DispatchQueue(label: "test", attributes: .concurrent)
        let group = DispatchGroup()

        // Concurrent locked read-modify-write through the atomic wrapper.
        for _ in 0..<100 {
            group.enter()
            queue.async {
                model.$counter.mutate { $0 += 1 }
                group.leave()
            }
        }

        group.wait()
        assertEqual(model.counter, 100, "All increments should be atomic")
    }

    test("Copy-on-write wrapper") {
        var model1 = DataModel()
        model1.largeData = [1, 2, 3, 4, 5]
        assertFalse(model1.$largeData, "No copy on a unique write")

        var model2 = model1
        model2.largeData.append(6)
        assertTrue(model2.$largeData, "Mutating while shared makes a copy")
        assertEqual(model1.largeData, [1, 2, 3, 4, 5], "Original is unchanged")
        assertEqual(model2.largeData, [1, 2, 3, 4, 5, 6], "Copy has the mutation")
    }

    test("Optional property wrapper") {
        var model = DataModel()

        model.input = "  Hello World  "
        assertEqual(model.input, "Hello World", "Should trim whitespace")

        model.input = nil
        assertNil(model.input, "Should handle nil")

        model.input = "\n\tTest\n\t"
        assertEqual(model.input, "Test", "Should trim all whitespace")
    }

    test("Composed property wrappers") {
        var model = DataModel()

        model.percentage = 150
        assertEqual(model.percentage, 100, "Should be clamped to 100")

        model.percentage = -10
        assertEqual(model.percentage, 0, "Should be clamped to 0")
    }

    test("Lazy property wrapper") {
        struct ExpensiveData {
            @Lazy var computed: String = {
                print("Computing expensive value...")
                return "Expensive Result"
            }()
        }

        var data = ExpensiveData()

        assertFalse(data.$computed, "Not initialized yet")

        let value1 = data.computed
        assertEqual(value1, "Expensive Result", "Should compute value")
        assertTrue(data.$computed, "Should be initialized")

        let value2 = data.computed
        assertEqual(value2, "Expensive Result", "Should return cached value")
    }

    runTests()
}
