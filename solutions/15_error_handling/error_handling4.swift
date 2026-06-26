// error_handling4.swift
//
// Advanced error handling with do-catch patterns and error transformation.
// LocalizedError protocol provides user-friendly error messages.
//
// Fix the error handling patterns to make the tests pass.

import Foundation

enum AppError: Error {
    case networkUnavailable
    case invalidCredentials
    case serverError(message: String)
    case unknown
}

// The standard library already gives Result `get()` and `mapError(_:)`, so we
// add something it does not have: a non-throwing accessor for the value.
extension Result {
    func valueOrNil() -> Success? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
}

func performComplexOperation() throws {
    let random = Int.random(in: 1...4)

    switch random {
    case 1: throw AppError.networkUnavailable
    case 2: throw AppError.invalidCredentials
    case 3: throw NSError(domain: "TestDomain", code: 42)
    default: return
    }
}

func handleComplexOperation() -> String {
    do {
        try performComplexOperation()
        return "Success"
    } catch AppError.networkUnavailable {
        return "Network unavailable"
    } catch AppError.invalidCredentials {
        return "Invalid credentials"
    } catch let error as NSError {
        return "Unknown error: \(error.code)"
    }
}

func fetchUserData(id: Int, completion: @escaping (Result<String, AppError>) -> Void) {
    DispatchQueue.global().async {
        if id < 0 {
            completion(.failure(.invalidCredentials))
        } else if id == 0 {
            completion(.failure(.serverError(message: "User not found")))
        } else {
            completion(.success("User \(id)"))
        }
    }
}

func getUserSync(id: Int) throws -> String {
    var result: Result<String, AppError>?
    let semaphore = DispatchSemaphore(value: 0)

    fetchUserData(id: id) { fetchResult in
        result = fetchResult
        semaphore.signal()
    }

    semaphore.wait()

    return try result!.get()
}

func main() {
    print("error: \(AppError.networkUnavailable.errorDescription ?? "?")")

    test("LocalizedError implementation") {
        let error1 = AppError.networkUnavailable
        assertEqual(error1.errorDescription, "Network connection is unavailable",
                   "Network error description")

        let error2 = AppError.invalidCredentials
        assertEqual(error2.errorDescription, "Invalid username or password",
                   "Credentials error description")

        let error3 = AppError.serverError(message: "Database offline")
        assertEqual(error3.errorDescription, "Server error: Database offline",
                   "Server error with message")
    }

    test("Result extensions") {
        let success: Result<Int, AppError> = .success(42)
        do {
            let value = try success.get()
            assertEqual(value, 42, "Get success value")
        } catch {
            assertFalse(true, "Should not throw for success")
        }

        let failure: Result<Int, AppError> = .failure(.unknown)
        do {
            _ = try failure.get()
            assertFalse(true, "Should throw for failure")
        } catch AppError.unknown {
            assertTrue(true, "Threw correct error")
        } catch {
            assertFalse(true, "Wrong error type")
        }

        assertEqual(success.valueOrNil(), 42, "valueOrNil returns the success value")
        assertNil(failure.valueOrNil(), "valueOrNil returns nil for a failure")
    }

    test("Multiple error handling") {
        var results: [String] = []

        for _ in 1...200 {
            results.append(handleComplexOperation())
        }

        assertTrue(results.contains("Network unavailable"), "Should handle network error")
        assertTrue(results.contains("Invalid credentials"), "Should handle credentials error")
        assertTrue(results.contains("Unknown error: 42"), "Should handle NSError")
        assertTrue(results.contains("Success"), "Should handle success case")
    }

    test("Async to sync conversion") {
        do {
            let user = try getUserSync(id: 1)
            assertEqual(user, "User 1", "Valid user fetched")
        } catch {
            assertFalse(true, "Should not throw for valid ID")
        }

        do {
            _ = try getUserSync(id: -1)
            assertFalse(true, "Should throw for negative ID")
        } catch AppError.invalidCredentials {
            assertTrue(true, "Caught credentials error")
        } catch {
            assertFalse(true, "Wrong error type")
        }

        do {
            _ = try getUserSync(id: 0)
            assertFalse(true, "Should throw for zero ID")
        } catch AppError.serverError(let message) {
            assertEqual(message, "User not found", "Server error message")
        } catch {
            assertFalse(true, "Wrong error type")
        }
    }

    runTests()
}

// LocalizedError extension
extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .networkUnavailable:
            return "Network connection is unavailable"
        case .invalidCredentials:
            return "Invalid username or password"
        case .serverError(let message):
            return "Server error: \(message)"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}
