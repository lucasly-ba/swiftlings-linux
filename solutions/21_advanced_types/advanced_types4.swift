// advanced_types4.swift
//
// Advanced generic programming with conditional conformances and type constraints.
// Pushing Swift's type system to its limits.
//
// Fix the advanced generic patterns to make the tests pass.

struct Box<T> {
    let value: T
}

extension Box: Equatable where T: Equatable {
    static func == (lhs: Box, rhs: Box) -> Bool {
        return lhs.value == rhs.value
    }
}

struct Pair<First, Second> {
    let first: First
    let second: Second
}

extension Pair: Equatable where First: Equatable, Second: Equatable {
    static func == (lhs: Pair, rhs: Pair) -> Bool {
        return lhs.first == rhs.first && lhs.second == rhs.second
    }
}

extension Pair: Hashable where First: Hashable, Second: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(first)
        hasher.combine(second)
    }
}

struct OrderedSet<Element: Comparable> {
    private(set) var elements: [Element] = []

    mutating func insert(_ element: Element) {
        guard !elements.contains(element) else { return }
        let index = elements.firstIndex { $0 > element } ?? elements.count
        elements.insert(element, at: index)
    }

    func contains(_ element: Element) -> Bool {
        return elements.contains(element)
    }
}

protocol Addable {
    static func +(lhs: Self, rhs: Self) -> Self
}

extension Int: Addable {}
extension Double: Addable {}
extension String: Addable {}

func sum<C: Collection>(_ collection: C) -> C.Element where C.Element: Addable {
    let array = Array(collection)
    return array.dropFirst().reduce(array[0]) { $0 + $1 }
}

protocol TreeNode {
    associatedtype Value
    associatedtype Child: TreeNode

    var value: Value { get }
    var children: [Child] { get }
}

// A class (reference type) so a node can refer to other nodes; a struct cannot
// recursively contain itself.
final class BinaryNode<T>: TreeNode {
    let value: T
    let left: BinaryNode<T>?
    let right: BinaryNode<T>?

    init(value: T, left: BinaryNode<T>?, right: BinaryNode<T>?) {
        self.value = value
        self.left = left
        self.right = right
    }

    var children: [BinaryNode<T>] {
        return [left, right].compactMap { $0 }
    }
}

struct AnyFunctor<Container, Element> {
    let container: Container

    init(container: Container) {
        self.container = container
    }

    init(container: Container, element: Element) {
        self.container = container
    }

    func map<U>(_ transform: (Element) -> U) -> AnyFunctor<Container, U> {
        return AnyFunctor<Container, U>(container: container)
    }
}

func zip<A, B>(_ a: [A], _ b: [B]) -> [(A, B)] {
    var result: [(A, B)] = []
    for i in 0..<min(a.count, b.count) {
        result.append((a[i], b[i]))
    }
    return result
}

func zip<A, B, C>(_ a: [A], _ b: [B], _ c: [C]) -> [(A, B, C)] {
    var result: [(A, B, C)] = []
    for i in 0..<min(min(a.count, b.count), c.count) {
        result.append((a[i], b[i], c[i]))
    }
    return result
}

// Swift has no generic associated types, so BoolType is a plain marker and the
// type-level operations are expressed as generic typealiases on True / False.
protocol BoolType {}

struct True: BoolType {
    typealias And<Other: BoolType> = Other
    typealias Or<Other: BoolType> = True
    typealias Not = False
}

struct False: BoolType {
    typealias And<Other: BoolType> = False
    typealias Or<Other: BoolType> = Other
    typealias Not = True
}

func main() {
    print("advanced_types4: conditional conformance and constraints")

    test("Conditional conformance") {
        let box1 = Box(value: 42)
        let box2 = Box(value: 42)
        let box3 = Box(value: 99)

        assertTrue(box1 == box2, "Equal boxes")
        assertFalse(box1 == box3, "Different boxes")

        struct NotEquatable {}
        let box4 = Box(value: NotEquatable())
        let box5 = Box(value: NotEquatable())
        _ = box4
        _ = box5
    }

    test("Multiple conditional conformances") {
        let pair1 = Pair(first: "Hello", second: 42)
        let pair2 = Pair(first: "Hello", second: 42)
        let pair3 = Pair(first: "World", second: 42)

        assertTrue(pair1 == pair2, "Equal pairs")
        assertFalse(pair1 == pair3, "Different pairs")

        var set = Set<Pair<String, Int>>()
        set.insert(pair1)
        set.insert(pair2)
        assertEqual(set.count, 1, "Duplicate not inserted")
    }

    test("Generic with constraints") {
        var set = OrderedSet<Int>()
        set.insert(3)
        set.insert(1)
        set.insert(4)
        set.insert(1)  // Duplicate
        set.insert(2)

        assertEqual(set.elements, [1, 2, 3, 4], "Ordered unique elements")
        assertTrue(set.contains(3), "Contains 3")
        assertFalse(set.contains(5), "Doesn't contain 5")
    }

    test("Protocol with Self requirements") {
        let numbers = [1, 2, 3, 4, 5]
        assertEqual(sum(numbers), 15, "Sum of integers")

        let doubles = [1.5, 2.5, 3.0]
        assertEqual(sum(doubles), 7.0, "Sum of doubles")

        let strings = ["Hello", " ", "World"]
        assertEqual(sum(strings), "Hello World", "Concatenated strings")
    }

    test("Recursive constraints") {
        let tree = BinaryNode(
            value: 1,
            left: BinaryNode(value: 2, left: nil, right: nil),
            right: BinaryNode(
                value: 3,
                left: BinaryNode(value: 4, left: nil, right: nil),
                right: nil
            )
        )

        assertEqual(tree.value, 1, "Root value")
        assertEqual(tree.children.count, 2, "Two children")
        assertEqual(tree.children[0].value, 2, "Left child")
        assertEqual(tree.children[1].value, 3, "Right child")
    }

    test("Higher-kinded types simulation") {
        let numbers = AnyFunctor(container: [1, 2, 3], element: 0)
        let doubled = numbers.map { $0 * 2 }
        _ = doubled

        assertTrue(true, "Functor map simulation")
    }

    test("Variadic generics simulation") {
        let a = [1, 2, 3]
        let b = ["a", "b", "c"]
        let c = [true, false, true]

        let zipped2 = zip(a, b)
        assertEqual(zipped2.count, 3, "Zipped pairs")
        assertEqual(zipped2[0].0, 1, "First element of first pair")
        assertEqual(zipped2[0].1, "a", "Second element of first pair")

        let zipped3 = zip(a, b, c)
        assertEqual(zipped3.count, 3, "Zipped triples")
        assertEqual(zipped3[1].2, false, "Third element of second triple")
    }

    test("Type-level computation") {
        typealias T = True
        typealias F = False

        typealias TandT = T.And<T>
        assertTrue(TandT.self == True.self, "True AND True = True")

        typealias TorF = T.Or<F>
        assertTrue(TorF.self == True.self, "True OR False = True")

        typealias NotF = F.Not
        assertTrue(NotF.self == True.self, "NOT False = True")
    }

    runTests()
}

// Helper for type equality check. Compare the type identities, not the
// metatypes with == (that would call this function again and recurse forever).
func ==<T, U>(_ lhs: T.Type, _ rhs: U.Type) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}
