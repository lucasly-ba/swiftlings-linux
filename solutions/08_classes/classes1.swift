// classes1.swift
//
// Classes are reference types that support inheritance and other OOP features.
// Unlike structs, classes don't get automatic memberwise initializers.
//
// Fix the class definitions and usage to make the tests pass.

class Vehicle {
    var brand: String
    var model: String
    var year: Int

    init(brand: String, model: String, year: Int) {
        self.brand = brand
        self.model = model
        self.year = year
    }
}

class Car: Vehicle {
    var numberOfDoors: Int

    init(brand: String, model: String, year: Int, numberOfDoors: Int) {
        self.numberOfDoors = numberOfDoors
        super.init(brand: brand, model: model, year: year)
    }
}

func createVehicles() -> (vehicle: Vehicle, car: Car) {
    let vehicle = Vehicle(brand: "Generic", model: "Model", year: 2024)
    let car = Car(brand: "Honda", model: "Civic", year: 2023, numberOfDoors: 4)

    return (vehicle, car)
}

func testReferenceSemantics() -> (original: Int, modified: Int) {
    let car1 = Car(brand: "Toyota", model: "Camry", year: 2020, numberOfDoors: 4)
    let car2 = car1  // Reference, not copy

    car2.year = 2021

    return (car1.year, car2.year)
}

func main() {
    let v = createVehicles()
    print("vehicle \(v.vehicle.brand) \(v.vehicle.year), car \(v.car.brand) with \(v.car.numberOfDoors) doors")

    test("Class creation") {
        let (vehicle, car) = createVehicles()

        assertEqual(vehicle.brand, "Generic", "Vehicle brand")
        assertEqual(vehicle.model, "Model", "Vehicle model")
        assertEqual(vehicle.year, 2024, "Vehicle year")

        assertEqual(car.brand, "Honda", "Car brand")
        assertEqual(car.model, "Civic", "Car model")
        assertEqual(car.year, 2023, "Car year")
        assertEqual(car.numberOfDoors, 4, "Car doors")
    }

    test("Reference semantics") {
        let (original, modified) = testReferenceSemantics()
        assertEqual(original, 2021, "Original should be modified")
        assertEqual(modified, 2021, "Both should have same value")
    }

    runTests()
}
