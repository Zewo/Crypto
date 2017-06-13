import XCTest
@testable import Crypto

class CryptoTests: XCTestCase {
    func testExample() throws {
        print(Crypto.argon2(password: "password", salt: "somesalt"))
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
