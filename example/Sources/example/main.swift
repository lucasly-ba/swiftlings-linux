import Foundation

let name = "Swift"
print("Bonjour depuis SwiftPM, \(name)")
print("UUID:", UUID().uuidString.prefix(8))
print("Date OK:", Date().timeIntervalSince1970 > 0)
