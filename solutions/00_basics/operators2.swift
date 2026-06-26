// operators2.swift
//
// Comparison and logical operators are essential for control flow.
// Fix the boolean expressions to make the assertions pass.


/// Function that checks various conditions using comparison and logical operators
func checkConditions(age: Int, hasLicense: Bool) -> (isAdult: Bool, canDrive: Bool, isTeenager: Bool) {
    let isAdult = age >= 18
    let canDrive = hasLicense && isAdult

    let isTeenager = age >= 13 && age <= 19

    return (isAdult, canDrive, isTeenager)
}

func test() {
    let result1 = checkConditions(age: 18, hasLicense: true)
    assertTrue(result1.isAdult, "18 year old should be considered an adult")
    assertTrue(result1.canDrive, "18 year old with license should be able to drive")
    assertTrue(result1.isTeenager, "18 year old should be considered a teenager")

    let result2 = checkConditions(age: 16, hasLicense: true)
    assertFalse(result2.isAdult, "16 year old should not be considered an adult")
    assertFalse(result2.canDrive, "16 year old should not be able to drive (even with license)")
    assertTrue(result2.isTeenager, "16 year old should be considered a teenager")

    let result3 = checkConditions(age: 21, hasLicense: false)
    assertTrue(result3.isAdult, "21 year old should be considered an adult")
    assertFalse(result3.canDrive, "21 year old without license should not be able to drive")
    assertFalse(result3.isTeenager, "21 year old should not be considered a teenager")

    let result4 = checkConditions(age: 13, hasLicense: false)
    assertTrue(result4.isTeenager, "13 year old should be considered a teenager")

    let result5 = checkConditions(age: 19, hasLicense: true)
    assertTrue(result5.isTeenager, "19 year old should be considered a teenager")
    assertTrue(result5.canDrive, "19 year old with license should be able to drive")
}

func main() {
    let r = checkConditions(age: 18, hasLicense: true)
    print("age 18 with license: adult \(r.isAdult), canDrive \(r.canDrive), teenager \(r.isTeenager)")

    test()
    runTests()
}
