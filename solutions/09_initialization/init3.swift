// init3.swift
//
// A class has designated initializers that fully set up the instance, and
// convenience initializers that delegate to a designated one with self.init.
//
// Fix the convenience initializer so it calls the designated initializer.

class Temperature {
    let celsius: Double

    // Designated initializer.
    init(celsius: Double) {
        self.celsius = celsius
    }

    convenience init(fahrenheit: Double) {
        self.init(celsius: (fahrenheit - 32) / 1.8)
    }
}

func test() {
    assertEqual(Temperature(celsius: 25).celsius, 25, "designated initializer stores celsius")
    assertEqual(Temperature(fahrenheit: 212).celsius, 100, "convenience converts F to C")
}

func main() {
    print("212F = \(Temperature(fahrenheit: 212).celsius)C")

    test()
    runTests()
}
