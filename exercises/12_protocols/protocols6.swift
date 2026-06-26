// protocols6.swift
//
// Comparable lets you sort values and use <, >, and so on. CustomStringConvertible
// lets you decide how a value prints by giving it a `description`.
//
// Fix the type so it conforms to Comparable and CustomStringConvertible.

struct Version {
    let major: Int
    let minor: Int

    // TODO: Make Version conform to Comparable and CustomStringConvertible.
    //   description should read like "1.2"
    //   < should order by major first, then minor
}

func test() {
    let versions = [
        Version(major: 2, minor: 0),
        Version(major: 1, minor: 5),
        Version(major: 1, minor: 2),
    ]
    let sorted = versions.sorted()
    assertEqual(sorted.map { $0.description }, ["1.2", "1.5", "2.0"], "versions sort ascending")
    assertTrue(Version(major: 1, minor: 0) < Version(major: 1, minor: 1), "1.0 is less than 1.1")
    assertEqual("\(Version(major: 3, minor: 4))", "3.4", "description prints major.minor")
}

func main() {
    test()
    runTests()
}
