// tuples1.swift
//
// A tuple groups several values into one compound value. The values can have
// different types, and you can give each element a name.
//
// Fix the tuples so the tests pass.

/// Build a few tuples in different styles.
func makeTuples() -> (pair: (Int, Int), point: (x: Int, y: Int), entry: (String, Int)) {
    // TODO: A tuple literal needs parentheses around its values
    let pair = 1, 2

    // TODO: Give this tuple the element names x and y
    let point = (10, 20)

    // TODO: A tuple separates its values with commas, not a colon
    let entry = ("age": 30)

    return (pair, point, entry)
}

/// Read values back out of a named tuple.
func describePoint(_ point: (x: Int, y: Int)) -> String {
    // TODO: Read the elements by their names, x and y
    // Expected for (x: 3, y: 4): "Point at 3, 4"
    return "Point at \(point.first), \(point.second)"
}

func test() {
    let made = makeTuples()
    assertTrue(made.pair == (1, 2), "pair should be the tuple (1, 2)")
    assertEqual(made.point.x, 10, "point.x should be 10")
    assertEqual(made.point.y, 20, "point.y should be 20")
    assertEqual(made.entry.0, "age", "entry's first element should be \"age\"")
    assertEqual(made.entry.1, 30, "entry's second element should be 30")
    assertEqual(describePoint((x: 3, y: 4)), "Point at 3, 4", "describePoint should read the named elements")
}

func main() {
    test()
    runTests()
}
