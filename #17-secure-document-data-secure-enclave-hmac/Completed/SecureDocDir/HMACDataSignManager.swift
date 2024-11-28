//
//  HMACDataSignManager.swift
//  SecureDocDir
//
//  Created by Alfian Losari on 28/11/24.
//

import CryptoKit
import Foundation

struct HMACDataSignManager {
    
    let keyTag: String
    
    init(keyTag: String = "com.alfianlosari.secureDocDir.key.hmac") {
        self.keyTag = keyTag
    }
    
    func sign(data: Data) throws -> Data {
        // Sign encrypted data with HMAC
        let hmacKey = try generateHMACKey()
        let hmac = HMAC<SHA256>.authenticationCode(for: data as Data, using: hmacKey)
        
        // Combine encrypted data and HMAC signature
        var signedData = Data()
        signedData.append(data)
        signedData.append(Data(hmac))
        return signedData
    }
    
    func validateHMAC(signedData: Data) throws -> Data {
          // Split data into encrypted content and HMAC signature
          let hmacSize = 32 // HMAC-SHA256 produces a 32-byte hash
          let encryptedData = signedData[..<(signedData.count - hmacSize)]
          let storedHMAC = signedData[(signedData.count - hmacSize)...]
          
          // Validate HMAC
          let hmacKey = try generateHMACKey()
          let computedHMAC = HMAC<SHA256>.authenticationCode(for: encryptedData, using: hmacKey)
          
          guard Data(computedHMAC) == storedHMAC else {
              throw NSError(domain: "SecureDataManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "HMAC validation failed. Data might be tampered with."])
          }
          return encryptedData
      }
    
    private func storeHMACKey(_ keyData: Data) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keyTag,
            kSecValueData as String: keyData
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func getHMACKey() -> SymmetricKey? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keyTag,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess, let keyData = item as? Data else {
            return nil
        }
        return SymmetricKey(data: keyData)
    }
    
    private func generateHMACKey() throws -> SymmetricKey {
        if let storedKey = getHMACKey() {
            return storedKey
        }
        
        let newKey = SymmetricKey(size: .bits256)
        let keyData = newKey.withUnsafeBytes { Data($0) }
        storeHMACKey(keyData)
        return newKey
    }

    
}
