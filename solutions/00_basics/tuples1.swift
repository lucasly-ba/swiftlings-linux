// tuples1.swift
//
// A tuple groups several values into one compound value. The values can have
// different types, and you can give each element a name.
//
// Fix the tuples so the tests pass.

/// Build a few tuples in different styles.
func makeTuples() -> (pair: (Int, Int), point: (x: Int, y: Int), entry: (String, Int)) {
    let pair = (1, 2)

    let point = (x: 10, y: 20)

    let entry = ("age", 30)

    return (pair, point, entry)
}

/// Read values back out of a named tuple.
func describePoint(_ point: (x: Int, y: Int)) -> String {
    return "Point at \(point.x), \(point.y)"
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
    let made = makeTuples()
    print("point \(made.point), \(describePoint((x: 3, y: 4)))")

    test()
    runTests()
}
