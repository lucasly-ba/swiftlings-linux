// strings4.swift
//
// A String is a sequence of Characters, so you can iterate it with for-in.
// Strings also have helpers like split, contains, and replacingOccurrences.
//
// Fix the text helpers to make the tests pass.

import Foundation

/// Count how many words are in a sentence (words are separated by single spaces).
func wordCount(_ sentence: String) -> Int {
    return sentence.split(separator: " ").count
}

/// Count the vowels by looking at each Character in turn.
func vowelCount(_ text: String) -> Int {
    let vowels: Set<Character> = ["a", "e", "i", "o", "u"]
    var count = 0
    for character in text {
        if vowels.contains(character) {
            count += 1
        }
    }
    return count
}

/// Replace every "cat" with "dog", and report whether the text mentioned a cat.
func replaceCats(in text: String) -> (result: String, mentionedCat: Bool) {
    let mentionedCat = text.contains("cat")
    let result = text.replacingOccurrences(of: "cat", with: "dog")
    return (result, mentionedCat)
}

func test() {
    assertEqual(wordCount("the quick brown fox"), 4, "should count 4 words")
    assertEqual(vowelCount("education"), 5, "education has 5 vowels")
    let changed = replaceCats(in: "my cat and another cat")
    assertEqual(changed.result, "my dog and another dog", "every cat should become dog")
    assertTrue(changed.mentionedCat, "should detect the word cat anywhere in the text")
}

func main() {
    print("words \(wordCount("the quick brown fox")), vowels \(vowelCount("education"))")

    test()
    runTests()
}
