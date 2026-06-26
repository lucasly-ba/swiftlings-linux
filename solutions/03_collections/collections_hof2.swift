// collections_hof2.swift
//
// reduce combines all the elements of a collection into a single value.
// flatMap, used here on a nested array, flattens one level of nesting.
//
// Note: these use closure syntax. You will learn closures in 05_closures. Here
// you only need to fill in the short bodies between the braces.
//
// Fix the functions to make the tests pass.

/// Sum the lengths of all the words.
func totalLength(of words: [String]) -> Int {
    return words.reduce(0) { $0 + $1.count }
}

/// Flatten a list of lists into a single list.
func flatten(_ nested: [[Int]]) -> [Int] {
    return nested.flatMap { $0 }
}

func test() {
    assertEqual(totalLength(of: ["red", "green", "blue"]), 12, "3 + 5 + 4 should be 12")
    assertEqual(flatten([[1, 2], [3], [4, 5]]), [1, 2, 3, 4, 5], "nested arrays should be flattened")
}

func main() {
    print("total length \(totalLength(of: ["red", "green", "blue"])), flattened \(flatten([[1, 2], [3], [4, 5]]))")

    test()
    runTests()
}
