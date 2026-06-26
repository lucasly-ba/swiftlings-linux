// types2.swift
//
// Swift can automatically infer types from initial values.
// But sometimes we need to be explicit about types.
//
// Fix this code by adding necessary type annotations or initial values.


/// Function that demonstrates type inference and explicit type annotations
func getMeasurements() -> (temperature: Double, price: Double, message: String) {
    let temperature: Double
    temperature = 25.5

    let price: Double = 100

    let message = "The temperature is \(temperature)°C"

    return (temperature, price, message)
}

func test() {
    let result = getMeasurements()

    assertEqual(result.temperature, 25.5, "Temperature should be 25.5")
    assertTrue(type(of: result.temperature) == Double.self, "Temperature should be of type Double")

    assertEqual(result.price, 100.0, "Price should be 100.0")
    assertTrue(type(of: result.price) == Double.self, "Price should be of type Double, not Int")

    assertEqual(result.message, "The temperature is 25.5°C", "Message should interpolate temperature correctly")

    let discountedPrice = result.price * 0.9
    assertEqual(discountedPrice, 90.0, "Should be able to perform floating-point operations on price")
}

func main() {
    let m = getMeasurements()
    print("\(m.message), price \(m.price)")

    test()
    runTests()
}
