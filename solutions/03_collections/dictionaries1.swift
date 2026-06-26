// dictionaries1.swift
//
// Dictionaries store key-value pairs in an unordered collection.
// Each key must be unique and acts as an identifier for its value.
//
// Fix the dictionary operations to make the tests pass.

func createDictionaries() -> ([String: Int], [Int: String], [String: Double]) {
    let ages = ["Alice": 25, "Bob": 30, "Charlie": 35]

    let numberNames: [Int: String] = [:]

    let prices = ["apple": 0.99, "banana": 0.59, "orange": 0.79]

    return (ages, numberNames, prices)
}

func dictionaryOperations() -> (age: Int?, count: Int, names: [String]) {
    var people = ["Alice": 25, "Bob": 30]

    people["Charlie"] = 35

    let bobAge = people["Bob"]

    let count = people.count

    let names = people.keys

    return (bobAge, count, Array(names).sorted())
}

func main() {
    let ops = dictionaryOperations()
    print("Bob is \(ops.age ?? 0), \(ops.count) people")

    test("Dictionary creation") {
        let (ages, numbers, prices) = createDictionaries()
        assertEqual(ages["Alice"], 25, "Alice should be 25")
        assertEqual(ages["Bob"], 30, "Bob should be 30")
        assertTrue(numbers.isEmpty, "Numbers dictionary should be empty")
        assertEqual(prices["apple"], 0.99, "Apple price should be 0.99")
    }

    test("Dictionary operations") {
        let result = dictionaryOperations()
        assertEqual(result.age, 30, "Bob's age should be 30")
        assertEqual(result.count, 3, "Should have 3 people")
        assertEqual(result.names, ["Alice", "Bob", "Charlie"], "Should have all names sorted")
    }

    runTests()
}
