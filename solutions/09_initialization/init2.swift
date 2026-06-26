// init2.swift
//
// A failable initializer, written `init?`, can return nil when the inputs are
// not valid. This is common when parsing untrusted input into a typed value.
//
// Fix the initializer so it fails for invalid port numbers.

struct Port {
    let number: Int

    init?(_ text: String) {
        guard let value = Int(text), (1...65535).contains(value) else {
            return nil
        }
        self.number = value
    }
}

func test() {
    assertEqual(Port("8080")?.number, 8080, "a valid port parses")
    assertNil(Port("abc"), "a non-number is nil")
    assertNil(Port("70000"), "out of range is nil")
    assertNil(Port("0"), "0 is not a valid port")
}

func main() {
    print("port 8080 -> \(Port("8080")?.number ?? -1), abc -> \(Port("abc")?.number ?? -1)")

    test()
    runTests()
}
