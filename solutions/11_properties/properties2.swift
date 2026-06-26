// properties2.swift
//
// Property observers, willSet and didSet, run code when a stored property
// changes. didSet is handy for keeping a value within bounds after it is set.
//
// Fix the observer so volume is always kept within 0...11.

struct Speaker {
    var volume: Int = 0 {
        didSet {
            volume = min(11, max(0, volume))
        }
    }
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
    var speaker = Speaker()
    speaker.volume = 20
    print("volume clamps 20 -> \(speaker.volume)")

    test()
    runTests()
}
