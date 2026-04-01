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

/// AES encryption/decryption helpers.
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public extension ZDCrypto {
    /// Errors thrown by AES-GCM helpers.
    private enum AESGCMError: Error {
        case invalidKey
        case invalidCiphertext
        case sealFailed
        case openFailed
    }

    /// Builds a `SymmetricKey` from a plain string key.
    ///
    /// - Parameters:
    ///   - key: Raw key string.
    /// - Returns: A `SymmetricKey` instance.
    private static func aesKey(from key: String) throws -> SymmetricKey {
        guard let keyData = key.data(using: .utf8) else {
            throw AESGCMError.invalidKey
        }
        return SymmetricKey(data: keyData)
    }

    /// Encrypts plaintext with AES-GCM.
    ///
    /// - Parameters:
    ///   - plaintext: Plain text to encrypt.
    ///   - key: Key string used for encryption.
    /// - Returns: Base64 encoded string of `nonce + ciphertext + tag`.
    ///
    /// Example:
    /// ```swift
    /// let encrypted = try ZDCrypto.aesEncrypt(
    ///     plaintext: "hello",
    ///     key: "1234567890123456"
    /// )
    /// ```
    static func aesEncrypt(plaintext: String, key: String, aad: Data? = nil) throws -> String {
        let key = try aesKey(from: key)
        let data = Data(plaintext.utf8)
        // Random 12-byte nonce.
        let nonce = AES.GCM.Nonce()
        // Seal plaintext.
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

    /// Decrypts a Base64 encoded AES-GCM payload string.
    ///
    /// - Parameters:
    ///   - encodedText: Base64 payload produced by `aesEncrypt`.
    ///   - key: Key string used for decryption.
    /// - Returns: Decrypted plaintext string.
    ///
    /// Example:
    /// ```swift
    /// let text = try ZDCrypto.aesDecrypt(
    ///     encodedText: encrypted,
    ///     key: "1234567890123456"
    /// )
    /// ```
    static func aesDecrypt(encodedText: String, key: String, aad: Data? = nil) throws -> String {
        guard let encodedData = Data(base64Encoded: encodedText) else {
            throw AESGCMError.invalidCiphertext
        }
        let decodedData = try aesDecrypt(data: encodedData, key: key, aad: aad)
        guard let plaintext = String(data: decodedData, encoding: .utf8) else {
            throw AESGCMError.openFailed
        }
        #if DEBUG
        debugPrint("Decrypted plaintext = \(plaintext)")
        #endif
        return plaintext
    }

    /// Decrypts raw AES-GCM payload data.
    ///
    /// - Parameters:
    ///   - data: Raw payload data (`nonce + ciphertext + tag`).
    ///   - key: Key string used for decryption.
    /// - Returns: Decrypted data.
    ///
    /// Example:
    /// ```swift
    /// let raw = Data(base64Encoded: encrypted)!
    /// let plainData = try ZDCrypto.aesDecrypt(data: raw, key: "1234567890123456")
    /// ```
    static func aesDecrypt(data: Data, key: String, aad: Data? = nil) throws -> Data {
        // Split into 12-byte nonce, ciphertext and 16-byte tag.
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
