//
//  ZDCrypto.swift
//  Pods
//
//  Created by Zero_D_Saber on 2025/8/7.
//

import CryptoKit
import Foundation

// MARK: - ZDCrypto

public struct ZDCrypto {}

/// AES加解密
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public extension ZDCrypto {
    /// 加密失败时抛出的错误
    private enum AESGCMError: Error {
        case invalidKey
        case invalidCiphertext
        case sealFailed
        case openFailed
    }

    /// 字符串`key`生成`SymmetricKey`类型
    ///
    /// - Parameters:
    ///   - key: 加密key
    /// - Returns: SymmetricKey对象
    private static func aesKey(from key: String) throws -> SymmetricKey {
        guard let keyData = key.data(using: .utf8) else {
            throw AESGCMError.invalidKey
        }
        return SymmetricKey(data: keyData)
    }

    /// 加密
    ///
    /// - Parameters:
    ///   - plaintext: 要做加密处理的普通字符串
    ///   - key: 加密对应的字符key
    /// - Returns: 加密后的字符串
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
    ///
    /// - Parameters:
    ///   - encodedText: 要做解密处理的加密字符串
    ///   - key: 解密对应的字符key
    /// - Returns: 解密后的字符串
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

    /// 解密
    ///
    /// - Parameters:
    ///   - data: 未加密的`data`数据
    ///   - key: 解密需要的key
    /// - Returns: 解密后的`data`数据
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
