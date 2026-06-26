// classes4.swift
//
// Classes can use lazy properties, property observers, and class methods.
// Understanding when to use class vs static is important.
//
// Fix the property declarations and class methods to make the tests pass.

class DataLoader {
    let url: String

    lazy var data: String = {
        print("Loading data from \(self.url)")
        return "Data from \(self.url)"
    }()

    init(url: String) {
        self.url = url
        print("DataLoader initialized")
    }
}

class Configuration {
    static let shared = Configuration()

    var settings: [String: Any] = [:] {
        didSet {
            // Observe configuration changes here.
        }
    }

    init() {}

    class func reset() {
        shared.settings = [:]
    }
}

class DebugConfiguration: Configuration {
    override class func reset() {
        super.reset()
        shared.settings["debug"] = true
    }
}

class Counter {
    static var totalCount = 0

    var count = 0 {
        didSet {
            Counter.totalCount += (count - oldValue)
        }
    }

    func increment() {
        count += 1
    }

    static func getTotalCount() -> Int {
        return totalCount
    }
}

func main() {
    print("counter total starts at \(Counter.getTotalCount())")

    test("Lazy properties") {
        print("Creating DataLoader...")
        let loader = DataLoader(url: "https://example.com")
        print("DataLoader created, data not loaded yet")

        // Access lazy property
        let data = loader.data
        assertEqual(data, "Data from https://example.com", "Lazy loaded data")

        // Second access doesn't reload
        let data2 = loader.data
        assertEqual(data2, "Data from https://example.com", "Same data returned")
    }

    test("Singleton and class methods") {
        Configuration.shared.settings["theme"] = "dark"
        assertEqual(Configuration.shared.settings["theme"] as? String, "dark",
                   "Singleton settings")

        Configuration.reset()
        assertTrue(Configuration.shared.settings.isEmpty,
                  "Settings cleared after reset")

        let debug = DebugConfiguration()
        _ = debug
        DebugConfiguration.reset()
        assertEqual(Configuration.shared.settings["debug"] as? Bool, true,
                   "Debug configuration adds debug flag")
    }

    test("Static properties") {
        assertEqual(Counter.getTotalCount(), 0, "Initial total is 0")

        let c1 = Counter()
        c1.increment()
        c1.increment()

        let c2 = Counter()
        c2.increment()

        assertEqual(Counter.getTotalCount(), 3, "Total across all instances")
        assertEqual(c1.count, 2, "Instance 1 count")
        assertEqual(c2.count, 1, "Instance 2 count")
    }

    runTests()
}
