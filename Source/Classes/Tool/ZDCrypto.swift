//
//  ZDCrypto.swift
//  Pods
//
//  Created by Zero_D_Saber on 2025/8/7.
//

import CryptoKit
import Foundation

struct ZDCrypto {}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension ZDCrypto {
    /// 加密失败时抛出的错误
    private enum AESGCMError: Error {
        case invalidKey
        case invalidCiphertext
        case sealFailed
        case openFailed
    }

    /// 从 Base64 字符串加载 256 位 key
    private static func aesKey(from base64Key: String) throws -> SymmetricKey {
        guard let keyData = Data(base64Encoded: base64Key),
              keyData.count == 32
        else {
            throw AESGCMError.invalidKey
        }
        return SymmetricKey(data: keyData)
    }

    /// 加密
    static func aesEncrypt(plaintext: String, key: String, aad: Data? = nil) throws -> String {
        let key = try aesKey(from: key)
        let data = Data(plaintext.utf8)
        // 随机 12 字节 nonce
        let nonce = AES.GCM.Nonce()
        // 密封
        let sealedBox: AES.GCM.SealedBox
        do {
            sealedBox = try AES.GCM.seal(data, using: key, nonce: nonce, authenticating: aad ?? Data())
        } catch {
            throw AESGCMError.sealFailed
        }
        // IV || ciphertext || tag
        let combined = nonce + sealedBox.ciphertext + sealedBox.tag
        return combined.base64EncodedString()
    }

    /// 解密
    static func aesDecrypt(encodedText: String, key: String, aad: Data? = nil) throws -> String {
        guard let encodedData = encodedText.data(using: .utf8) else {
            throw AESGCMError.invalidCiphertext
        }
        let decodedData = try aesDecrypt(data: encodedData, key: key, aad: aad)
        guard let plaintext = String(data: decodedData, encoding: .utf8) else {
            throw AESGCMError.openFailed
        }
        #if DEBUG
            debugPrint("解密后的明文 = \(plaintext)")
        #endif
        return plaintext
    }

    /// - Parameters:
    ///   - data: 普通的data
    ///   - key: 盐key
    static func aesDecrypt(data: Data, key: String, aad: Data? = nil) throws -> Data {
        // 拆分：12-byte nonce, 剩下前 ciphertext，后 16-byte tag
        let nonceData = data.prefix(12)
        let tagData = data.suffix(16)
        let cipherData = data.dropFirst(12).dropLast(16)
        let nonce = try AES.GCM.Nonce(data: nonceData)
        let sealedBox = try AES.GCM.SealedBox(
            nonce: nonce,
            ciphertext: cipherData,
            tag: tagData
        )
        let decrypted: Data
        do {
            let aesKey = try aesKey(from: key)
            decrypted = try AES.GCM.open(sealedBox, using: aesKey, authenticating: aad ?? Data())
        } catch {
            throw AESGCMError.openFailed
        }
        return decrypted
    }
}
