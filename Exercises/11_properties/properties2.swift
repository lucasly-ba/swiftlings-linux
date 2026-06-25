// properties2.swift
//
// Property observers, willSet and didSet, run code when a stored property
// changes. didSet is handy for keeping a value within bounds after it is set.
//
// Fix the observer so volume is always kept within 0...11.

struct Speaker {
    // TODO: Add a didSet observer to `volume` that clamps it into 0...11
    // (anything below 0 becomes 0, anything above 11 becomes 11).
    var volume: Int = 0
}

func test() {
    var speaker = Speaker()
    speaker.volume = 5
    assertEqual(speaker.volume, 5, "5 is in range")
    speaker.volume = 20
    assertEqual(speaker.volume, 11, "above 11 clamps to 11")
    speaker.volume = -3
    assertEqual(speaker.volume, 0, "below 0 clamps to 0")
}

func main() {
    test()
    runTests()
}
