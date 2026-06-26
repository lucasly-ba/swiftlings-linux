// sets1.swift
//
// Sets are unordered collections of unique values.
// They're perfect when you need to ensure uniqueness or perform set operations.
//
// Fix the set operations to make the tests pass.

func createSets() -> (numbers: Set<Int>, empty: Set<String>, fromArray: Set<Character>) {
    let numbers: Set = [1, 2, 3, 4, 5]

    let empty = Set<String>()

    let letters: [Character] = ["a", "b", "c", "a", "b"]
    let fromArray = Set(letters)

    return (numbers, empty, fromArray)
}

func setOperations() -> (union: Set<Int>, intersection: Set<Int>, difference: Set<Int>) {
    let evens: Set = [2, 4, 6, 8, 10]
    let primes: Set = [2, 3, 5, 7, 11]

    let union = evens.union(primes)

    let intersection = evens.intersection(primes)

    let difference = evens.subtracting(primes)

    return (union, intersection, difference)
}

func main() {
    let ops = setOperations()
    print("intersection \(ops.intersection.sorted()), difference \(ops.difference.sorted())")

    test("Set creation") {
        let (nums, empty, chars) = createSets()
        assertEqual(nums, Set([1, 2, 3, 4, 5]), "Numbers set")
        assertTrue(empty.isEmpty, "Empty set should be empty")
        assertEqual(chars, Set(["a", "b", "c"]), "Should have unique characters")
    }

    test("Set operations") {
        let result = setOperations()
        assertEqual(result.union, Set([2, 3, 4, 5, 6, 7, 8, 10, 11]), "Union of sets")
        assertEqual(result.intersection, Set([2]), "Only 2 is in both sets")
        assertEqual(result.difference, Set([4, 6, 8, 10]), "Evens minus primes")
    }

    runTests()
}
