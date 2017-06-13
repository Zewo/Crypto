import Core
import CLibreSSL

extension Crypto {
    public static func sha256(
        _ string: String,
        buffer: UnsafeMutableRawBufferPointer
    ) -> UnsafeRawBufferPointer {
        guard buffer.count >= Int(SHA256_DIGEST_LENGTH) else {
            // invalid buffer size
            return UnsafeRawBufferPointer(start: nil, count: 0)
        }
        
        var sha256 = SHA256_CTX()
        SHA256_Init(&sha256)
        
        _ = string.withCString {
            SHA256_Update(&sha256, $0, string.utf8.count)
        }
        
        SHA256_Final(buffer.baseAddress?.assumingMemoryBound(to: UInt8.self), &sha256)
        
        return UnsafeRawBufferPointer(rebasing: buffer.prefix(Int(SHA256_DIGEST_LENGTH)))
    }
    
    public static func sha256<B : BufferInitializable>(_ string: String) -> B  {
        let buffer = UnsafeMutableRawBufferPointer.allocate(count: Int(SHA256_DIGEST_LENGTH))
        
        defer {
            buffer.deallocate()
        }
        
        return B(sha256(string, buffer: buffer))
    }
}
