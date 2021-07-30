import Foundation

enum ProcessError: Error {
    case code(Int32)
}

@available(macOS 10.13, *)
@discardableResult
func executeAndWait(_ program: String, at dir: String, arguments: [String]) throws -> String? {
    
    let proc = Process()
    let stdout = Pipe()
    
    proc.executableURL = pathToEnv
    proc.arguments = [program] + arguments
    proc.standardOutput = stdout
    proc.currentDirectoryPath = dir
    
    try proc.run()
    proc.waitUntilExit()
    
    guard proc.terminationStatus == 0 else {
        throw ProcessError.code(proc.terminationStatus)
    }
    
    return String(
        data: stdout.fileHandleForReading.readDataToEndOfFile(),
        encoding: .utf8
    )?.trimmingCharacters(in: .whitespacesAndNewlines)
}
