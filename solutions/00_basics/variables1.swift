// variables1.swift
//
// Variables in Swift are declared using the `var` keyword.
// They can be changed after they're created.
//
// Fix the function below to make the tests pass.

func createVariable() -> Int {
    // TODO: 'x' needs to hold 5 and still be changeable on the next line.
    var x = 5

    x = x + 1

    return x
}

func main() {
    let result = createVariable()
    print("x is now \(result)")

    test("Variable can be created and modified") {
        assertEqual(result, 6, "Variable should be incremented to 6")
    }

    runTests()
}
