// types1.swift
//
// Swift is a type-safe language. Every variable and constant has a specific type.
// Swift can infer types, but sometimes we need to be explicit.
//
// Fix the type annotations in this code.


/// Function that demonstrates explicit type annotations
func getLanguageInfo() -> (name: String, year: Int, version: Double) {
    let name: String = "Swift"

    let year: Int = 2024

    let version: Double = 5.9

    return (name, year, version)
}

func test() {
    let info = getLanguageInfo()

    assertEqual(info.name, "Swift", "Name should be a String with value 'Swift'")
    assertEqual(info.year, 2024, "Year should be an Int with value 2024")
    assertEqual(info.version, 5.9, "Version should be a Double with value 5.9")

    let message = "\(info.name) was introduced in \(info.year)"
    assertEqual(message, "Swift was introduced in 2024", "Should be able to interpolate values correctly")

    let nextYear = info.year + 1
    assertEqual(nextYear, 2025, "Should be able to perform integer arithmetic")

    let versionTimes10 = info.version * 10.0
    assertEqual(versionTimes10, 59.0, "Should be able to perform floating-point arithmetic")
}

func main() {
    let info = getLanguageInfo()
    print("\(info.name) \(info.version), introduced in \(info.year)")

    test()
    runTests()
}
