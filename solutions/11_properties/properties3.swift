// properties3.swift
//
// A lazy stored property is not created until the first time it is used. This
// is useful when the value is expensive to build and might not be needed.
//
// Fix the class so the expensive value is only built on first access.

// A counter so the test can see how many times the expensive work ran.
nonisolated(unsafe) var buildCount = 0

func expensiveValue() -> Int {
    buildCount += 1
    return 42
}

class Report {
    lazy var data: Int = expensiveValue()
}

func test() {
    buildCount = 0
    let report = Report()
    assertEqual(buildCount, 0, "creating a Report should not build data yet")
    assertEqual(report.data, 42, "reading data builds it")
    assertEqual(buildCount, 1, "data is built exactly once")
    _ = report.data
    assertEqual(buildCount, 1, "reading again does not rebuild")
}

func main() {
    let report = Report()
    print("report data \(report.data)")

    test()
    runTests()
}
