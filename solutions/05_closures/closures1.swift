// closures1.swift
//
// Closures are self-contained blocks of functionality.
// They can capture and store references to constants and variables.
//
// Fix the closure syntax and usage to make the tests pass.

let addClosure = { (a: Int, b: Int) -> Int in
    return a + b
}

let multiplyClosure: (Int, Int) -> Int = { a, b in
    a * b
}

func performOperation(on a: Int, and b: Int, operation: (Int, Int) -> Int) -> Int {
    return operation(a, b)
}

func calculate() -> (sum: Int, product: Int) {
    let x = 5
    let y = 3

    let sum = performOperation(on: x, and: y) { $0 + $1 }

    let product = performOperation(on: x, and: y) { $0 * $1 }

    return (sum, product)
}

func makeIncrementer(by amount: Int) -> () -> Int {
    var total = 0

    return {
        total += amount
        return total
    }
}

func processNumbers(_ numbers: [Int]) -> (doubled: [Int], evens: [Int], sum: Int) {
    let doubled = numbers.map { $0 * 2 }

    let evens = numbers.filter { $0 % 2 == 0 }

    let sum = numbers.reduce(0) { $0 + $1 }

    return (doubled, evens, sum)
}

func main() {
    let c = calculate()
    print("add \(addClosure(3, 5)), multiply \(multiplyClosure(4, 7)), sum \(c.sum), product \(c.product)")

    test("Basic closure syntax") {
        assertEqual(addClosure(3, 5), 8, "Closure addition")
        assertEqual(multiplyClosure(4, 7), 28, "Closure multiplication")
    }

    test("Trailing closure syntax") {
        let (sum, product) = calculate()
        assertEqual(sum, 8, "Sum using trailing closure")
        assertEqual(product, 15, "Product using shorthand")
    }

    test("Capturing values") {
        let incrementByTwo = makeIncrementer(by: 2)
        assertEqual(incrementByTwo(), 2, "First increment")
        assertEqual(incrementByTwo(), 4, "Second increment")
        assertEqual(incrementByTwo(), 6, "Third increment")

        let incrementByFive = makeIncrementer(by: 5)
        assertEqual(incrementByFive(), 5, "Different incrementer")
        assertEqual(incrementByTwo(), 8, "Original still works")
    }

    test("Higher-order functions") {
        let numbers = [1, 2, 3, 4, 5]
        let (doubled, evens, sum) = processNumbers(numbers)

        assertEqual(doubled, [2, 4, 6, 8, 10], "Map doubles numbers")
        assertEqual(evens, [2, 4], "Filter finds evens")
        assertEqual(sum, 15, "Reduce calculates sum")
    }

    runTests()
}
