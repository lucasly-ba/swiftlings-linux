import Foundation

/// Handles exercise compilation
final class ExerciseCompiler {
  private let processRunner: ProcessRunning
  private let fileManager: FileManager

  init(
    processRunner: ProcessRunning = ProcessRunner(),
    fileManager: FileManager = .default
  ) {
    self.processRunner = processRunner
    self.fileManager = fileManager
  }

  /// Compile exercise files
  func compile(
    exercise: Exercise,
    in directory: URL,
    includeAssert: Bool
  ) throws -> CompilationResult {
    // Force colored diagnostics. swiftc turns color off when its output is not
    // a terminal, and the runner always captures it through a pipe, so without
    // this the compiler errors come out as plain text.
    var compileArgs = [
      "-color-diagnostics",
      "-o", "exercise",
      "main.swift",
      "\(exercise.name).swift",
    ]

    if includeAssert && fileManager.fileExists(atPath: directory.appendingPathComponent("Assert.swift").path) {
      compileArgs.append("Assert.swift")
    }

    let result = try processRunner.run(
      executable: Configuration.Executables.swiftc,
      arguments: compileArgs,
      currentDirectory: directory
    )

    if result.isSuccess {
      return .success(output: result.stdout)
    } else {
      let errorOutput = result.stderr.isEmpty ? result.stdout : result.stderr
      return .failure(message: errorOutput)
    }
  }
}

/// Result of compilation
enum CompilationResult {
  case success(output: String)
  case failure(message: String)

  var isSuccess: Bool {
    switch self {
      case .success:
        return true
      case .failure:
        return false
    }
  }
}
