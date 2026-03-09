import Foundation
import CommonCrypto

func decryptFromUrlSafe(_ cipherText: String) -> String {
    let keyString = "zJ8mL3pQvXyT1aWfB9sN5dCgKoE7RuZh"

    var base64 = cipherText
        .replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")

    // Restore Base64 padding
    let padding = 4 - base64.count % 4
    if padding < 4 {
        base64 += String(repeating: "=", count: padding)
    }

    guard let encryptedData = Data(base64Encoded: base64),
          let keyData = keyString.data(using: .utf8) else {
        return cipherText
    }

    // SHA-256 of key
    var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
    keyData.withUnsafeBytes {
        _ = CC_SHA256($0.baseAddress, CC_LONG(keyData.count), &hash)
    }

    let aesKey = Data(hash)
    let iv = Data(hash.prefix(16))

    var decryptedData = Data(count: encryptedData.count)
    let decryptedDataLength = decryptedData.count   //  FIX
    var bytesDecrypted: size_t = 0

    let status = decryptedData.withUnsafeMutableBytes { decryptedBytes in
        encryptedData.withUnsafeBytes { encryptedBytes in
            aesKey.withUnsafeBytes { keyBytes in
                iv.withUnsafeBytes { ivBytes in
                    CCCrypt(
                        CCOperation(kCCDecrypt),
                        CCAlgorithm(kCCAlgorithmAES),
                        CCOptions(kCCOptionPKCS7Padding),
                        keyBytes.baseAddress, kCCKeySizeAES256,
                        ivBytes.baseAddress,
                        encryptedBytes.baseAddress, encryptedData.count,
                        decryptedBytes.baseAddress, decryptedDataLength,
                        &bytesDecrypted
                    )
                }
            }
        }
    }

    guard status == kCCSuccess else {
        return cipherText
    }

    decryptedData.removeSubrange(bytesDecrypted..<decryptedData.count)
    return String(data: decryptedData, encoding: .utf8) ?? cipherText
}



func encryptToUrlSafe(_ plainText: String) -> String {
    let keyString = "zJ8mL3pQvXyT1aWfB9sN5dCgKoE7RuZh"
    
    guard let keyData = keyString.data(using: .utf8),
          let textData = plainText.data(using: .utf8) else {
        return plainText
    }

    // SHA-256 of key
    var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
    keyData.withUnsafeBytes {
        _ = CC_SHA256($0.baseAddress, CC_LONG(keyData.count), &hash)
    }

    let aesKey = Data(hash)                  // 32 bytes
    let iv = Data(hash.prefix(16))           // first 16 bytes

    let cryptLength = textData.count + kCCBlockSizeAES128
    var cryptData = Data(count: cryptLength)

    var bytesEncrypted: size_t = 0

    let status = cryptData.withUnsafeMutableBytes { cryptBytes in
        textData.withUnsafeBytes { dataBytes in
            aesKey.withUnsafeBytes { keyBytes in
                iv.withUnsafeBytes { ivBytes in
                    CCCrypt(
                        CCOperation(kCCEncrypt),
                        CCAlgorithm(kCCAlgorithmAES),
                        CCOptions(kCCOptionPKCS7Padding),
                        keyBytes.baseAddress, kCCKeySizeAES256,
                        ivBytes.baseAddress,
                        dataBytes.baseAddress, textData.count,
                        cryptBytes.baseAddress, cryptLength,
                        &bytesEncrypted
                    )
                }
            }
        }
    }

    guard status == kCCSuccess else {
        return plainText
    }

    cryptData.removeSubrange(bytesEncrypted..<cryptData.count)

    // Base64 → URL safe
    let base64 = cryptData.base64EncodedString()
    let urlSafe = base64
        .replacingOccurrences(of: "+", with: "-")
        .replacingOccurrences(of: "/", with: "_")
        .replacingOccurrences(of: "=", with: "")

    return urlSafe
}
