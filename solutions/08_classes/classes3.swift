// classes3.swift
//
// Classes can have deinitializers and type properties/methods.
// Access control restricts visibility of properties and methods.
//
// Fix the access control and type members to make the tests pass.

class FileHandler {
    private var fileHandle: String?

    static var openFileCount = 0

    let filename: String

    init(filename: String) {
        self.filename = filename
        FileHandler.openFileCount += 1
    }

    deinit {
        FileHandler.openFileCount -= 1
    }

    private func openFile() {
        fileHandle = "Handle for \(filename)"
        print("Opened \(filename)")
    }

    // Public method that uses private method
    func readContents() -> String {
        if fileHandle == nil {
            openFile()
        }
        return "Contents of \(filename)"
    }

    static func getOpenFileCount() -> Int {
        return openFileCount
    }
}

class BankVault {
    private var balance: Double = 0
    let vaultID: String
    private var pin: String

    init(vaultID: String, pin: String) {
        self.vaultID = vaultID
        self.pin = pin
    }

    private func verifyPin(_ inputPin: String) -> Bool {
        return inputPin == pin
    }

    // Public methods that use private data
    func deposit(_ amount: Double, pin: String) -> Bool {
        guard verifyPin(pin) else { return false }
        balance += amount
        return true
    }

    func checkBalance(_ pin: String) -> Double? {
        guard verifyPin(pin) else { return nil }
        return balance
    }
}

func main() {
    let vault = BankVault(vaultID: "VAULT123", pin: "1234")
    _ = vault.deposit(100, pin: "1234")
    print("vault \(vault.vaultID) balance \(vault.checkBalance("1234") ?? -1)")

    test("Static properties and deinit") {
        assertEqual(FileHandler.getOpenFileCount(), 0, "No files open initially")

        var handler1: FileHandler? = FileHandler(filename: "test1.txt")
        var handler2: FileHandler? = FileHandler(filename: "test2.txt")
        assertEqual(FileHandler.getOpenFileCount(), 2, "Two files open")

        handler1 = nil  // Should trigger deinit
        assertEqual(FileHandler.getOpenFileCount(), 1, "One file after deinit")

        handler2 = nil
        assertEqual(FileHandler.getOpenFileCount(), 0, "No files after all deinit")
    }

    test("Access control") {
        let vault = BankVault(vaultID: "VAULT123", pin: "1234")

        // These should work through public interface
        assertTrue(vault.deposit(100.0, pin: "1234"), "Deposit with correct pin")
        assertFalse(vault.deposit(50.0, pin: "0000"), "Deposit with wrong pin")

        assertEqual(vault.checkBalance("1234"), 100.0, "Check balance with correct pin")
        assertNil(vault.checkBalance("0000"), "Check balance with wrong pin")

        // vaultID should be accessible
        assertEqual(vault.vaultID, "VAULT123", "Vault ID is public")
    }

    runTests()
}
