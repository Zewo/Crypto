import Core
import CArgon2

extension Crypto {
    public static func argon2(password: String, salt: String) -> String {
        var encoded = [Int8](repeating: 0, count: 108)
        
        let result = encoded.withUnsafeMutableBufferPointer { encoded in
            password.withCString { passwordPointer in
                salt.withCString { saltPointer in
                    argon2i_hash_encoded(
                        2,
                        65536,
                        1,
                        UnsafeRawPointer(passwordPointer),
                        password.utf8.count,
                        saltPointer,
                        salt.utf8.count,
                        32,
                        encoded.baseAddress,
                        encoded.count
                    )
                }
            }
        }
        
        guard result == ARGON2_OK.rawValue else {
            return String(cString: argon2_error_message(result))
        }
        
        return String(cString: encoded + [0])
    }
}
