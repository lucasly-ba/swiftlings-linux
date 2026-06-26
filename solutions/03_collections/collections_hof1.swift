// collections_hof1.swift
//
// map transforms every element of a collection. filter keeps only the elements
// that match a condition. Both take a closure.
//
// Note: these use closure syntax. You will learn closures in 05_closures. Here
// you only need to fill in the short bodies between the braces.
//
// Fix the transformations to make the tests pass.

func transformNumbers(_ numbers: [Int]) -> (squares: [Int], evens: [Int]) {
    let squares = numbers.map { $0 * $0 }

    let evens = numbers.filter { $0 % 2 == 0 }

    return (squares, evens)
}

func test() {
    let result = transformNumbers([1, 2, 3, 4, 5])
    assertEqual(result.squares, [1, 4, 9, 16, 25], "each number should be squared")
    assertEqual(result.evens, [2, 4], "only even numbers should remain")
}

func main() {
    let result = transformNumbers([1, 2, 3, 4, 5])
    print("squares \(result.squares), evens \(result.evens)")

    test()
    runTests()
}
