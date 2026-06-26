// init1.swift
//
// A struct gets a memberwise initializer for free. You can also write your own
// initializer to validate or transform the inputs before they are stored.
//
// Fix the struct so its initializer clamps the value into 0...100.

struct Percentage {
    let value: Int

    init(value: Int) {
        self.value = min(100, max(0, value))
    }
}

func test() {
    assertEqual(Percentage(value: 50).value, 50, "50 stays 50")
    assertEqual(Percentage(value: -10).value, 0, "below 0 clamps to 0")
    assertEqual(Percentage(value: 150).value, 100, "above 100 clamps to 100")
}

func main() {
    print("clamped: 150 -> \(Percentage(value: 150).value), -10 -> \(Percentage(value: -10).value)")

    test()
    runTests()
}
