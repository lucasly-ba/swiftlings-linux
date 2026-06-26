// arrays2.swift
//
// Arrays in Swift have many useful methods for manipulation.
// Let's explore adding, removing, and modifying array elements.
//
// Fix the array methods to make the tests pass.

func modifyArray() -> [String] {
    var fruits = ["apple", "banana"]

    fruits.append("orange")

    fruits.insert("mango", at: 1)

    fruits.removeLast()

    fruits[2] = "berry"

    return fruits
}

func arrayTransformations() -> (doubled: [Int], filtered: [Int], mapped: [String]) {
    let numbers = [1, 2, 3, 4, 5]

    let doubled = numbers.map { $0 * 2 }

    let filtered = numbers.filter { $0 % 2 == 0 }

    let mapped = numbers.map { "Item: \($0)" }

    return (doubled, filtered, mapped)
}

func main() {
    print("fruits \(modifyArray())")

    test("Array modifications") {
        let result = modifyArray()
        assertEqual(result, ["apple", "mango", "berry"], "Array should be modified correctly")
    }

    test("Array transformations") {
        let (doubled, filtered, mapped) = arrayTransformations()
        assertEqual(doubled, [2, 4, 6, 8, 10], "Numbers should be doubled")
        assertEqual(filtered, [2, 4], "Only even numbers should remain")
        assertEqual(mapped, ["Item: 1", "Item: 2", "Item: 3", "Item: 4", "Item: 5"],
                   "Numbers should be mapped to strings")
    }

    runTests()
}
