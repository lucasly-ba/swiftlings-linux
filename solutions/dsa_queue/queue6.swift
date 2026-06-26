// queue6.swift
//
// Data Structures: Queue - Collection Protocol Conformance
// Make Queue conform to Collection protocol for powerful functionality.
// This enables for-in loops, map, filter, and other collection operations.
//
// Implement Collection protocol conformance for Queue.

import Foundation

struct Queue<Element> {
    var elements: [Element] = []

    mutating func enqueue(_ element: Element) {
        elements.append(element)
    }

    mutating func dequeue() -> Element? {
        guard !elements.isEmpty else { return nil }
        return elements.removeFirst()
    }

    func peek() -> Element? {
        return elements.first
    }

    var isEmpty: Bool {
        return elements.isEmpty
    }
}

// Conforming to BidirectionalCollection (which refines Collection) also gives us
// `last`. The required members just forward to the backing array's indices.
extension Queue: BidirectionalCollection {
    var startIndex: Int { elements.startIndex }
    var endIndex: Int { elements.endIndex }

    subscript(position: Int) -> Element {
        return elements[position]
    }

    func index(after i: Int) -> Int {
        return elements.index(after: i)
    }

    func index(before i: Int) -> Int {
        return elements.index(before: i)
    }
}

func main() {
    var queue = Queue<Int>()
    queue.enqueue(1)
    queue.enqueue(2)
    queue.enqueue(3)
    print("sum \(queue.reduce(0, +)), doubled \(queue.map { $0 * 2 })")

    test("Collection count property") {
        var queue = Queue<Int>()
        queue.enqueue(1)
        queue.enqueue(2)
        queue.enqueue(3)

        assertEqual(queue.count, 3,
                   "Count should be 3")
    }

    test("Collection first and last properties") {
        var queue = Queue<String>()
        queue.enqueue("first")
        queue.enqueue("middle")
        queue.enqueue("last")

        assertEqual(queue.first, "first",
                   "First should be 'first'")
        assertEqual(queue.last, "last",
                   "Last should be 'last'")
    }

    test("For-in loop iteration") {
        var queue = Queue<Int>()
        queue.enqueue(10)
        queue.enqueue(20)
        queue.enqueue(30)

        var result: [Int] = []
        for element in queue {
            result.append(element)
        }

        assertEqual(result, [10, 20, 30],
                   "Should iterate in FIFO order")
    }

    test("Map and filter operations") {
        var queue = Queue<Int>()
        queue.enqueue(1)
        queue.enqueue(2)
        queue.enqueue(3)
        queue.enqueue(4)

        let doubled = queue.map { $0 * 2 }
        assertEqual(doubled, [2, 4, 6, 8],
                   "Map should double all elements")

        let evens = queue.filter { $0 % 2 == 0 }
        assertEqual(evens, [2, 4],
                   "Filter should return even numbers")
    }

    test("Contains and reduce operations") {
        var queue = Queue<Int>()
        queue.enqueue(5)
        queue.enqueue(10)
        queue.enqueue(15)

        assertEqual(queue.contains(10), true,
                   "Should contain 10")
        assertEqual(queue.contains(7), false,
                   "Should not contain 7")

        let sum = queue.reduce(0, +)
        assertEqual(sum, 30,
                   "Sum should be 30")
    }

    runTests()
}
