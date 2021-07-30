import IndexStoreDB
import Foundation

// MARK: - Configuration

// CHECK THAT PRECONDITIONS ARE MET!

/// This property must contain path to `env`. The path has to be equal
/// to the result of `$ which env` call in your terminal
let pathToEnv = URL(fileURLWithPath: "/usr/bin/env")

/// All of this is built upon presumption, that this variable contains the path to the package
///
/// Terminal output for me looked like this when printing the property:
/// ```
/// $ swift run
/// /Users/mikolasstuchlik/Developer/GLibISDemo
/// ```
///
/// Therefore I assume, there is a directory `.build` and this demo is Xcode incompatible
let pathToPackage = FileManager.default.currentDirectoryPath

// MARK: - Configure and build Swift package
let pathToGLib = pathToPackage + "/.build/checkouts/SwiftGLib"

if #available(macOS 10.13, *) {
    try! executeAndWait("swift", at: pathToGLib, arguments: ["build", "--target",  "SGLib", "--enable-index-store" ])
} else {
    fatalError()
}

// MARK: - Configure and run Index Store
let storePath = pathToGLib + "/.build/debug/index/store"

// Make sure this path is valid!
let lib = try IndexStoreLibrary(dylibPath: "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/libIndexStore.dylib")

let db = try IndexStoreDB(
    storePath: storePath,
    databasePath: NSTemporaryDirectory() + "db-demo",
    library: lib,
    waitUntilDoneInitializing: true,
    listenToUnitEvents: true
)

// MARK: - Examples
print(db.canonicalOccurrences(ofName: "Int"))
print(db.canonicalOccurrences(ofName: "CLongDouble"))

db.forEachSymbolName { name in
    if name.contains("g_object") { print(name) }
    return true
}

db.forEachSymbolName { name in
    if name.contains("GObject") { print(name) }
    return true
}
