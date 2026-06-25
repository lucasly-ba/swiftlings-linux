import Foundation

/// Watches a single file's modification time by polling. Call `hasChanged()`
/// from a loop; it returns true once after each time the file is saved.
final class FileWatcher {
  private let path: String
  private var lastModificationDate: Date?

  init(path: String) {
    self.path = path
    self.lastModificationDate = FileWatcher.modificationDate(of: path)
  }

  /// True if the file was saved since the last call (or since init).
  func hasChanged() -> Bool {
    guard let current = FileWatcher.modificationDate(of: path) else {
      return false
    }
    defer { lastModificationDate = current }
    if let last = lastModificationDate {
      return current > last
    }
    return false
  }

  private static func modificationDate(of path: String) -> Date? {
    let attributes = try? FileManager.default.attributesOfItem(atPath: path)
    return attributes?[.modificationDate] as? Date
  }
}
