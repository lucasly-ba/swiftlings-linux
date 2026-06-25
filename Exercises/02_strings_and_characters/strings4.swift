// strings4.swift
//
// A String is a sequence of Characters, so you can iterate it with for-in.
// Strings also have helpers like split, contains, and replacingOccurrences.
//
// Fix the text helpers to make the tests pass.

import Foundation

/// Count how many words are in a sentence (words are separated by single spaces).
func wordCount(_ sentence: String) -> Int {
    // TODO: Split the sentence on spaces and count the pieces, do not count
    // every character. Hint: "a b c".split(separator: " ") gives three pieces.
    return sentence.count
}

/// Count the vowels by looking at each Character in turn.
func vowelCount(_ text: String) -> Int {
    let vowels: Set<Character> = ["a", "e", "i", "o", "u"]
    var count = 0
    // TODO: Iterate over the characters of `text` and add 1 for each vowel.
    return count
}

/// Replace every "cat" with "dog", and report whether the text mentioned a cat.
func replaceCats(in text: String) -> (result: String, mentionedCat: Bool) {
    // TODO: hasPrefix only checks the start. Use contains to look anywhere.
    let mentionedCat = text.hasPrefix("cat")
    // TODO: Use replacingOccurrences(of:with:) to swap cat for dog.
    let result = text
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
    test()
    runTests()
}
