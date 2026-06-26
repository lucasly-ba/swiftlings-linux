// operators1.swift
//
// Swift has all the basic arithmetic operators you'd expect.
// Let's practice using them!
//
// Fix the calculations to get the expected results.


/// Function that performs basic arithmetic operations
func performCalculations(a: Int, b: Int) -> (sum: Int, difference: Int, product: Int, quotient: Int, remainder: Int) {
    let sum = a + b
    let difference = a - b
    let product = a * b
    let quotient = a / b
    let remainder = a % b

    return (sum, difference, product, quotient, remainder)
}

func test() {
    let result = performCalculations(a: 10, b: 3)

    assertEqual(result.sum, 13, "Sum of 10 and 3 should be 13")
    assertEqual(result.difference, 7, "Difference of 10 and 3 should be 7")
    assertEqual(result.product, 30, "Product of 10 and 3 should be 30")
    assertEqual(result.quotient, 3, "Quotient of 10 divided by 3 should be 3")
    assertEqual(result.remainder, 1, "Remainder of 10 divided by 3 should be 1")

    let result2 = performCalculations(a: 20, b: 4)
    assertEqual(result2.sum, 24, "Sum of 20 and 4 should be 24")
    assertEqual(result2.difference, 16, "Difference of 20 and 4 should be 16")
    assertEqual(result2.product, 80, "Product of 20 and 4 should be 80")
    assertEqual(result2.quotient, 5, "Quotient of 20 divided by 4 should be 5")
    assertEqual(result2.remainder, 0, "Remainder of 20 divided by 4 should be 0")
}

func main() {
    let r = performCalculations(a: 10, b: 3)
    print("10 and 3: sum \(r.sum), difference \(r.difference), product \(r.product), quotient \(r.quotient), remainder \(r.remainder)")

    test()
    runTests()
}
