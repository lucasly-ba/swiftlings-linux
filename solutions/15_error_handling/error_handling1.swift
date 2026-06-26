// error_handling1.swift
//
// Swift uses error handling to respond to recoverable errors.
// Functions that can throw errors are marked with 'throws'.
//
// Fix the error handling to make the tests pass.

import Foundation

enum ValidationError: Error {
    case tooShort
    case tooLong
    case invalidCharacters
}

func validateUsername(_ username: String) throws -> Bool {
    if username.count < 3 {
        throw ValidationError.tooShort
    }

    if username.count > 20 {
        throw ValidationError.tooLong
    }

    let validCharacters = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_"))
    if username.rangeOfCharacter(from: validCharacters.inverted) != nil {
        throw ValidationError.invalidCharacters
    }

    return true
}

func processUsername(_ username: String) -> String {
    do {
        _ = try validateUsername(username)
        return "Username '\(username)' is valid!"
    } catch ValidationError.tooShort {
        return "Username too short"
    } catch ValidationError.tooLong {
        return "Username too long"
    } catch ValidationError.invalidCharacters {
        return "Invalid characters in username"
    } catch {
        return "Invalid username"
    }
}

func checkUsername(_ username: String) -> Bool {
    return (try? validateUsername(username)) ?? false
}

func main() {
    print("alice -> \(processUsername("alice")), a -> \(processUsername("a"))")

    test("Basic error throwing") {
        do {
            _ = try validateUsername("ab")
            assertFalse(true, "Should throw tooShort error")
        } catch ValidationError.tooShort {
            assertTrue(true, "Caught tooShort error")
        } catch {
            assertFalse(true, "Wrong error type")
        }

        do {
            _ = try validateUsername("this_username_is_way_too_long")
            assertFalse(true, "Should throw tooLong error")
        } catch ValidationError.tooLong {
            assertTrue(true, "Caught tooLong error")
        } catch {
            assertFalse(true, "Wrong error type")
        }
    }

    test("Error handling in functions") {
        assertEqual(processUsername("alice"), "Username 'alice' is valid!",
                   "Valid username processed")
        assertEqual(processUsername("a"), "Username too short",
                   "Short username error message")
        assertEqual(processUsername("user@name"), "Invalid characters in username",
                   "Invalid characters error message")
    }

    test("Try optional") {
        assertTrue(checkUsername("validuser"), "Valid username returns true")
        assertFalse(checkUsername("no"), "Invalid username returns false")
        assertFalse(checkUsername("user name"), "Invalid username returns false")
    }

    runTests()
}
