// extensions1.swift
//
// Extensions add new functionality to existing types.
// You can extend types you don't own, including built-in types.
//
// Fix the extensions to make the tests pass.

extension Int {
    var isEven: Bool {
        return self % 2 == 0
    }

    func squared() -> Int {
        return self * self
    }
}

extension String {
    func trimmed() -> String {
        var result = self
        while result.hasPrefix(" ") { result.removeFirst() }
        while result.hasSuffix(" ") { result.removeLast() }
        return result
    }

    var wordCount: Int {
        return self.split(separator: " ").count
    }
}

extension Array where Element == Int {
    var sum: Int {
        return reduce(0, +)
    }

    func average() -> Double? {
        guard !isEmpty else { return nil }
        return Double(sum) / Double(count)
    }
}

extension Double {
    func rounded(to places: Int) -> Double {
        var divisor = 1.0
        for _ in 0..<places { divisor *= 10 }
        return (self * divisor).rounded() / divisor
    }
}

func main() {
    print("4.isEven \(4.isEven), 5.squared() \(5.squared()), sum \([1, 2, 3, 4, 5].sum)")

    test("Int extensions") {
        assertEqual(4.isEven, true, "4 is even")
        assertEqual(7.isEven, false, "7 is odd")
        assertEqual(5.squared(), 25, "5 squared is 25")
        assertEqual((-3).squared(), 9, "-3 squared is 9")
    }

    test("String extensions") {
        assertEqual("  Hello World  ".trimmed(), "Hello World", "Trimmed string")
        assertEqual("".trimmed(), "", "Empty string trimmed")

        assertEqual("Hello world from Swift".wordCount, 4, "Four words")
        assertEqual("".wordCount, 0, "Empty string has 0 words")
        assertEqual("   Multiple   spaces   ".wordCount, 2, "Two words with extra spaces")
    }

    test("Array<Int> extensions") {
        assertEqual([1, 2, 3, 4, 5].sum, 15, "Sum of 1-5")
        assertEqual([].sum, 0, "Empty array sum is 0")
        assertEqual([-1, -2, -3].sum, -6, "Sum of negatives")

        assertEqual([10, 20, 30].average(), 20.0, "Average of 10,20,30")
        assertEqual([5].average(), 5.0, "Average of single element")
        assertNil([].average(), "Empty array average is nil")
    }

    test("Double extensions") {
        assertEqual(3.14159.rounded(to: 2), 3.14, "Round to 2 places")
        assertEqual(3.14159.rounded(to: 4), 3.1416, "Round to 4 places")
        assertEqual(2.5.rounded(to: 0), 3.0, "Round to whole number")
    }

    runTests()
}
