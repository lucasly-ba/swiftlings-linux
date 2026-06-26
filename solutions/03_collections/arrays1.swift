// arrays1.swift
//
// Arrays are ordered collections of values of the same type.
// Swift arrays are type-safe and always clear about what they contain.
//
// Fix the array declarations and operations to make the tests pass.

func createArrays() -> ([Int], [String], [Double]) {
    let numbers = [1, 2, 3, 4, 5]

    let words: [String] = []

    let prices: [Double] = [9.99, 19.99, 29.99]

    return (numbers, words, prices)
}

func arrayOperations() -> (first: Int, count: Int, sum: Int) {
    let numbers = [10, 20, 30, 40, 50]

    let first = numbers[0]

    let count = numbers.count

    var sum = 0
    for number in numbers {
        sum += number
    }

    return (first, count, sum)
}

func main() {
    let ops = arrayOperations()
    print("array ops: first \(ops.first), count \(ops.count), sum \(ops.sum)")

    test("Array creation") {
        let (nums, words, prices) = createArrays()
        assertEqual(nums, [1, 2, 3, 4, 5], "Numbers array should contain 1-5")
        assertEqual(words, [], "Words should be empty array")
        assertEqual(prices, [9.99, 19.99, 29.99], "Prices should be doubles")
    }

    test("Array operations") {
        let result = arrayOperations()
        assertEqual(result.first, 10, "First element should be 10")
        assertEqual(result.count, 5, "Array has 5 elements")
        assertEqual(result.sum, 150, "Sum should be 150")
    }

    runTests()
}
