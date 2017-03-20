import XCTest
import PathKit
@testable import OctopusKit

class OctopusTests: XCTestCase {
    func testPackagePath() {
        let 🐙1 = Octopus(project: "/Users/xxx/Desktop/Test/Test.xcodeproj", scheme: "", info: "")
        XCTAssertTrue(🐙1.path == "/Users/xxx/Desktop/Test",
                      "\(🐙1.path) should be /Users/xxx/Desktop/Test")
        
        let 🐙2 = Octopus(project: "", scheme: "", info: "")
        XCTAssertTrue(🐙2.path == Path.current.description,
                      "\(🐙2.path) should be \(Path.current.description)")
    }

    static var allTests : [(String, (OctopusTests) -> () throws -> Void)] {
        return [
            ("testExample", testPackagePath),
        ]
    }
}
