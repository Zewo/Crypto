import Core
import CLibreSSL

extension Crypto {
    public static func hs256(
        _ string: String,
        key: UnsafeRawBufferPointer,
        buffer: UnsafeMutableRawBufferPointer
    ) -> UnsafeRawBufferPointer {
        guard buffer.count >= Int(EVP_MAX_MD_SIZE) else {
            // invalid buffer size
            return UnsafeRawBufferPointer(start: nil, count: 0)
        }
        
        var bufferCount: UInt32 = 0
        
        let result = string.withCString {
            HMAC(
                EVP_sha256(),
                key.baseAddress,
                Int32(key.count),
                UnsafeRawPointer($0).assumingMemoryBound(to: UInt8.self),
                string.utf8.count,
                buffer.baseAddress?.assumingMemoryBound(to: UInt8.self),
                &bufferCount
            )
        }
        
        guard result != nil else {
            return UnsafeRawBufferPointer(start: nil, count: 0)
        }
        
        return UnsafeRawBufferPointer(rebasing: buffer.prefix(upTo: Int(bufferCount)))
    }
    
    public static func hs256(
        _ string: String,
        key: BufferRepresentable,
        buffer: UnsafeMutableRawBufferPointer
    ) -> UnsafeRawBufferPointer {
        return key.withBuffer {
            hs256(string, key: $0, buffer: buffer)
        }
    }
    
    public static func hs256<B : BufferInitializable>(
        _ string: String,
        key: BufferRepresentable
    ) -> B {
        let buffer = UnsafeMutableRawBufferPointer.allocate(count: Int(EVP_MAX_MD_SIZE))
        
        defer {
            buffer.deallocate()
        }
        
        return B(hs256(string, key: key, buffer: buffer))
    }
}
