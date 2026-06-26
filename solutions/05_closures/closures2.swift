// closures2.swift
//
// Escaping closures outlive the function they're passed to.
// Autoclosures delay evaluation until they're called.
//
// Fix the escaping and autoclosure usage to make the tests pass.

import Foundation

class AsyncManager {
    private var completionHandlers: [() -> Void] = []

    func addCompletion(_ handler: @escaping () -> Void) {
        completionHandlers.append(handler)
    }

    func executeAll() {
        for handler in completionHandlers {
            handler()
        }
        completionHandlers.removeAll()
    }
}

func debugLog(_ message: @autoclosure () -> String, condition: Bool) {
    if condition {
        print("DEBUG: \(message())")
    }
}

func fetchData(
    onSuccess: @escaping (String) -> Void,
    onFailure: @escaping (Error) -> Void
) {
    // Call back straight from the background queue (no DispatchQueue.main hop)
    // so this works in a command-line program with no main run loop.
    DispatchQueue.global().async {
        let success = Bool.random()

        if success {
            onSuccess("Data loaded")
        } else {
            onFailure(NSError(domain: "Test", code: 1))
        }
    }
}

class Counter {
    var value = 0

    func incrementAsync(completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            self.value += 1
            completion()
        }
    }

    func incrementAsyncSafe(completion: @escaping () -> Void) {
        DispatchQueue.global().async { [weak self] in
            self?.value += 1
            completion()
        }
    }
}

typealias CompletionHandler<T> = (Result<T, Error>) -> Void

func performAsyncOperation<T>(
    producing value: T,
    completion: @escaping CompletionHandler<T>
) {
    DispatchQueue.global().async {
        Thread.sleep(forTimeInterval: 0.1)
        completion(.success(value))
    }
}

func main() {
    debugLog("ready", condition: true)

    test("Escaping closures") {
        let manager = AsyncManager()
        var results: [String] = []

        manager.addCompletion { results.append("First") }
        manager.addCompletion { results.append("Second") }
        manager.addCompletion { results.append("Third") }

        assertEqual(results, [], "Handlers not executed yet")

        manager.executeAll()
        assertEqual(results, ["First", "Second", "Third"], "All handlers executed")
    }

    test("Autoclosure") {
        // An @autoclosure only evaluates its expression when it is actually
        // called. We count how many times the message expression is built.
        var evaluationCount = 0
        func makeMessage(_ text: String) -> String {
            evaluationCount += 1
            return text
        }

        debugLog(makeMessage("This should log"), condition: true)
        debugLog(makeMessage("This should not log"), condition: false)

        debugLog(makeMessage("\(1 + 2 + 3 + 4 + 5)"), condition: false)

        assertEqual(evaluationCount, 1, "Only the logged message should be evaluated")
    }

    test("Multiple escaping closures") {
        let expectation = DispatchSemaphore(value: 0)
        var result: String?

        fetchData(
            onSuccess: { data in
                result = data
                expectation.signal()
            },
            onFailure: { error in
                result = "Error: \(error)"
                expectation.signal()
            }
        )

        expectation.wait()
        assertNotNil(result, "Should have a result")
        assertTrue(result == "Data loaded" || result!.contains("Error"),
                  "Valid result")
    }

    test("Capture lists") {
        var counter: Counter? = Counter()
        let expectation = DispatchSemaphore(value: 0)

        counter?.incrementAsyncSafe {
            expectation.signal()
        }

        weak var weakCounter = counter
        counter = nil

        expectation.wait()
        assertNil(weakCounter, "Counter should be released")
    }

    test("Generic escaping closures") {
        let expectation = DispatchSemaphore(value: 0)
        var result: Int?

        performAsyncOperation(producing: 42) { asyncResult in
            switch asyncResult {
            case .success(let value):
                result = value
            case .failure:
                result = -1
            }
            expectation.signal()
        }

        expectation.wait()
        assertEqual(result, 42, "Async operation completed")
    }

    runTests()
}
