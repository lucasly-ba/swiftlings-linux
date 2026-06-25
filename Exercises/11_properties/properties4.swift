// properties4.swift
//
// Static properties and methods belong to the type itself, not to an instance,
// so they are shared across all instances. A static method is a common place
// for a factory that builds new values.
//
// Fix the struct by adding a static counter and a static factory method.

struct User {
    let id: Int

    // TODO: Add a static var `count`, starting at 0, that tracks how many
    // users have been made.

    // TODO: Add a static method `make()` that increments count and returns a
    // new User whose id is the new count.
}

func test() {
    User.count = 0
    let first = User.make()
    let second = User.make()
    assertEqual(first.id, 1, "the first user has id 1")
    assertEqual(second.id, 2, "the second user has id 2")
    assertEqual(User.count, 2, "two users were made")
}

func main() {
    test()
    runTests()
}
