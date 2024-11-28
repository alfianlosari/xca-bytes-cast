//
//  SecureEnclaveManager.swift
//  SecureDocDir
//
//  Created by Alfian Losari on 28/11/24.
//

import CryptoKit
import Foundation
import Security

struct SecureEnclaveManager {
    
    let keyTag: String
    
    init(keyTag: String = "com.alfianlosari.SecureDocDir.keyTag") {
        self.keyTag = keyTag
    }
    
    func encrypt(data: Data) throws -> Data {
        let privateKey = try generatePrivateKey()
        guard let publicKey = getPublicKey(privateKey: privateKey) else {
            throw NSError(domain: "SecureEnclaveManager", code: Int(1), userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve public key"])
        }
        
        // Encrypt using Secure Enclave AES GCM
        var error: Unmanaged<CFError>?
        guard let encryptedData = SecKeyCreateEncryptedData(publicKey, .eciesEncryptionStandardX963SHA256AESGCM, data as CFData, &error) else {
            throw error!.takeRetainedValue() as Error
        }
        return encryptedData as Data
    }
    
    func decrypt(encryptedData: Data, privateKey: SecKey) throws -> Data {
        var error: Unmanaged<CFError>?
        guard let decryptedData = SecKeyCreateDecryptedData(privateKey, .eciesEncryptionStandardX963SHA256AESGCM, encryptedData as CFData, &error) else {
            throw error!.takeRetainedValue() as Error
        }
        return decryptedData as Data
    }
    
    func getPrivateKey() throws -> SecKey {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: keyTag,
            kSecReturnRef as String: true,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else {
            throw NSError(domain: "SecureEnclaveManager", code: Int(status), userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve private key"])
        }
        return item as! SecKey
    }
    
    private func generatePrivateKey() throws -> SecKey {
        // Check if the key already exists
        if let existingKey = try? getPrivateKey() {
            print("Retrieved from existing key")
            return existingKey
        }
        
        // Define key attributes
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom, // Elliptic Curve Key
            kSecAttrKeySizeInBits as String: 256,
            kSecAttrTokenID as String: kSecAttrTokenIDSecureEnclave,    // Use the Secure Enclave
            kSecPrivateKeyAttrs as String: [
                kSecAttrIsPermanent as String: true,
                kSecAttrApplicationTag as String: keyTag,               // Tag for key identification
                kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
            ]
        ]
        
        // Generate key pair
        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            throw error!.takeRetainedValue() as Error
        }
        
        return privateKey
    }
    
    private func getPublicKey(privateKey: SecKey) -> SecKey? {
        return SecKeyCopyPublicKey(privateKey)
    }
}
