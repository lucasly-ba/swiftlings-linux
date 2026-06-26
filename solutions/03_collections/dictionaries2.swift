// dictionaries2.swift
//
// Heads up: a dictionary subscript returns an optional, because the key might
// not be there. You will learn more about optionals in 06_optionals. For now,
// just follow the hints.
//
// Dictionary operations often involve optionals since keys might not exist.
// Let's practice safe dictionary access and updates.
//
// Fix the dictionary operations to handle optionals correctly.

func updateDictionary() -> [String: Int] {
    var scores = ["Alice": 90, "Bob": 85]

    scores["Bob"] = 95

    _ = scores.updateValue(88, forKey: "Charlie")

    scores.removeValue(forKey: "Alice")

    scores["David"] = nil

    return scores
}

func safeDictionaryAccess() -> (found: String, notFound: String, withDefault: Int) {
    let inventory = ["apples": 10, "bananas": 5, "oranges": 8]

    let bananas = inventory["bananas"]

    let withDefault = inventory["pears", default: 0]

    return (found: "\(bananas ?? 0) bananas",
            notFound: "No grapes",
            withDefault: withDefault)
}

func main() {
    print(safeDictionaryAccess().found)

    test("Dictionary updates") {
        let scores = updateDictionary()
        assertEqual(scores["Bob"], 95, "Bob's score should be 95")
        assertEqual(scores["Charlie"], 88, "Charlie's score should be 88")
        assertNil(scores["Alice"], "Alice should be removed")
        assertNil(scores["David"], "David should not exist")
    }

    test("Safe dictionary access") {
        let result = safeDictionaryAccess()
        assertEqual(result.found, "5 bananas", "Should find bananas")
        assertEqual(result.notFound, "No grapes", "Should handle missing key")
        assertEqual(result.withDefault, 0, "Should use default value")
    }

    runTests()
}
