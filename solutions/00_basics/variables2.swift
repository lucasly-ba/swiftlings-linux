// variables2.swift
//
// Variables can be changed after they're declared.
// Fix the code to properly modify the variable.

func countApples() -> (initial: Int, final: Int) {
    // TODO: Fix this declaration so we can modify the apple count.
    var apples = 3
    let initialCount = apples

    // I just bought 2 more apples! Update the count.
    apples = apples + 2

    return (initial: initialCount, final: apples)
}

func main() {
    let result = countApples()
    print("apples: started with \(result.initial), now \(result.final)")

    test("Can modify apple count") {
        assertEqual(result.initial, 3, "Should start with 3 apples")
        assertEqual(result.final, 5, "Should end with 5 apples after buying 2 more")
    }

    runTests()
}
