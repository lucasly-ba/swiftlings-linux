// error_handling3.swift
//
// Converting between error types and using Result type.
// Rethrowing functions can propagate errors from their function parameters.
// A `rethrows` function only throws when the closure you pass it throws, so
// the closures from 05_closures are the prerequisite here.
//
// Fix the error conversions and rethrowing to make the tests pass.

enum NetworkError: Error {
    case noConnection
    case timeout
    case serverError(code: Int)
}

enum DataError: Error {
    case invalidFormat
    case missingData
}

func fetchAndParse(url: String) throws -> String {
    // Simulate network fetch
    if url.isEmpty {
        throw NetworkError.noConnection
    }

    let data = try fetchData(from: url)

    let parsed = parseData(data)

    switch parsed {
    case .success(let value):
        return value
    case .failure(let error):
        throw error
    }
}

func fetchData(from url: String) throws -> String {
    if url == "timeout" {
        throw NetworkError.timeout
    }
    if url.hasPrefix("error") {
        throw NetworkError.serverError(code: 500)
    }
    return "raw_data_from_\(url)"
}

func parseData(_ data: String) -> Result<String, DataError> {
    if data.isEmpty {
        return .failure(.missingData)
    }
    if !data.hasPrefix("raw_data") {
        return .failure(.invalidFormat)
    }
    return .success("parsed: \(data)")
}

func performOperation<T>(_ operation: () throws -> T) rethrows -> T {
    return try operation()
}

func processMultipleUrls(_ urls: [String]) -> [Result<String, Error>] {
    return urls.map { url in
        do {
            let result = try fetchAndParse(url: url)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
}

enum ValidationError: Error {
    case outOfRange(value: Int, range: ClosedRange<Int>)
    case invalidInput(String)

    var description: String {
        switch self {
        case .outOfRange(let value, let range):
            return "Value \(value) is out of range \(range)"
        case .invalidInput(let input):
            return "Invalid input: \(input)"
        }
    }
}

func validateAge(_ age: Int) throws {
    let validRange = 0...150
    if !validRange.contains(age) {
        throw ValidationError.outOfRange(value: age, range: validRange)
    }
}

func main() {
    print("parsed: \((try? fetchAndParse(url: "valid.com")) ?? "?")")

    test("Error type conversion") {
        do {
            let result = try fetchAndParse(url: "valid.com")
            assertEqual(result, "parsed: raw_data_from_valid.com", "Valid URL parsed")
        } catch {
            assertFalse(true, "Should not throw for valid URL")
        }

        do {
            _ = try fetchAndParse(url: "")
            assertFalse(true, "Should throw noConnection")
        } catch NetworkError.noConnection {
            assertTrue(true, "Caught network error")
        } catch {
            assertFalse(true, "Wrong error type")
        }
    }

    test("Rethrowing functions") {
        let result1 = performOperation { "success" }
        assertEqual(result1, "success", "Non-throwing operation")

        do {
            _ = try performOperation {
                throw NetworkError.timeout
            }
            assertFalse(true, "Should rethrow error")
        } catch NetworkError.timeout {
            assertTrue(true, "Error was rethrown")
        } catch {
            assertFalse(true, "Wrong error type")
        }
    }

    test("Result type usage") {
        let urls = ["good.com", "", "timeout", "another.com"]
        let results = processMultipleUrls(urls)

        assertEqual(results.count, 4, "All URLs processed")

        switch results[0] {
        case .success(let value):
            assertTrue(value.contains("parsed"), "First URL succeeded")
        case .failure:
            assertFalse(true, "First URL should succeed")
        }

        switch results[1] {
        case .success:
            assertFalse(true, "Empty URL should fail")
        case .failure(let error):
            assertTrue(error is NetworkError, "Should be network error")
        }
    }

    test("Custom error with associated values") {
        do {
            try validateAge(200)
            assertFalse(true, "Should throw outOfRange")
        } catch let ValidationError.outOfRange(value, range) {
            assertEqual(value, 200, "Error contains value")
            assertEqual(range, 0...150, "Error contains range")
        } catch {
            assertFalse(true, "Wrong error type")
        }

        let error = ValidationError.invalidInput("test")
        assertEqual(error.description, "Invalid input: test", "Error description")
    }

    runTests()
}
