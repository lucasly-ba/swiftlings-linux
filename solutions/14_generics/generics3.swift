// generics3.swift
//
// Generic types can use associated types in protocols.
// Type erasure helps work with protocols that have associated types.
//
// Fix the associated types and type erasure to make the tests pass.

protocol DataStore {
    associatedtype Item

    mutating func store(_ item: Item)
    mutating func retrieve() -> Item?
    var count: Int { get }
}

struct Queue<T>: DataStore {
    private var items: [T] = []

    mutating func store(_ item: T) {
        items.append(item)
    }

    mutating func retrieve() -> T? {
        guard !items.isEmpty else { return nil }
        return items.removeFirst()
    }

    var count: Int {
        return items.count
    }
}

struct AnyDataStore<T> {
    private let _store: (T) -> Void
    private let _retrieve: () -> T?
    private let _count: () -> Int

    init<Store: DataStore>(_ store: Store) where Store.Item == T {
        // A captured var is shared by reference across these closures, so the
        // mutations performed through them persist between calls.
        var backing = store
        _store = { backing.store($0) }
        _retrieve = { backing.retrieve() }
        _count = { backing.count }
    }

    func store(_ item: T) {
        _store(item)
    }

    func retrieve() -> T? {
        return _retrieve()
    }

    var count: Int {
        return _count()
    }
}

protocol Cacheable {
    associatedtype Key: Hashable
    associatedtype Value

    mutating func cache(_ value: Value, for key: Key)
    func value(for key: Key) -> Value?
    mutating func removeAll()
}

struct Cache<K: Hashable, V>: Cacheable {
    private var storage: [K: V] = [:]

    mutating func cache(_ value: V, for key: K) {
        storage[key] = value
    }

    func value(for key: K) -> V? {
        return storage[key]
    }

    mutating func removeAll() {
        storage.removeAll()
    }
}

func main() {
    var queue = Queue<String>()
    queue.store("a")
    queue.store("b")
    print("queue count \(queue.count), first \(queue.retrieve() ?? "?")")

    test("DataStore with associated types") {
        var queue = Queue<String>()
        queue.store("first")
        queue.store("second")
        queue.store("third")

        assertEqual(queue.count, 3, "Queue has 3 items")
        assertEqual(queue.retrieve(), "first", "FIFO retrieval")
        assertEqual(queue.count, 2, "Queue has 2 items after retrieve")
    }

    test("Type erasure") {
        let queue = Queue<Int>()
        let anyStore = AnyDataStore(queue)

        anyStore.store(10)
        anyStore.store(20)

        assertEqual(anyStore.count, 2, "Type-erased store has 2 items")
        assertEqual(anyStore.retrieve(), 10, "Type-erased retrieve works")
    }

    test("Generic cache with associated types") {
        var cache = Cache<String, Int>()
        cache.cache(100, for: "score")
        cache.cache(5, for: "lives")

        assertEqual(cache.value(for: "score"), 100, "Retrieve cached score")
        assertEqual(cache.value(for: "lives"), 5, "Retrieve cached lives")
        assertNil(cache.value(for: "unknown"), "Unknown key returns nil")

        cache.removeAll()
        assertNil(cache.value(for: "score"), "Cache cleared")
    }

    test("Different cache types") {
        var userCache = Cache<Int, String>()
        userCache.cache("Alice", for: 1)
        userCache.cache("Bob", for: 2)

        assertEqual(userCache.value(for: 1), "Alice", "User 1 is Alice")
        assertEqual(userCache.value(for: 2), "Bob", "User 2 is Bob")
    }

    runTests()
}
