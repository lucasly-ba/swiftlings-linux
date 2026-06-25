// pour lancer ce fichier:   srun hello.swift
// ou en faire un binaire:    swiftc hello.swift -o hello && ./hello
//
// `swift hello.swift` marche aussi, mais seulement sans import Foundation.
// des qu'on importe Foundation, on passe par srun ou par SwiftPM.

import Foundation

let name = "Swift"
print("Bonjour, \(name)")

// petite nouveauté de Swift 5.9: le if qui renvoie une valeur
let level = 3
let label = if level > 2 { "avancé" } else { "débutant" }
print("Niveau: \(label)")

print("Identifiant unique: \(UUID().uuidString.prefix(8))")
