//
//  SecureDocumentDataManager.swift
//  SecureDocDir
//
//  Created by Alfian Losari on 28/11/24.
//

import Foundation
import CryptoKit
import Security

struct SecureDocumentDataManager {
    
    let secureEnclaveManager: SecureEnclaveManager
    let hmacDataSignManager: HMACDataSignManager
    
    var url: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func save(data: Data, filename: String) throws {
        let encryptedData = try secureEnclaveManager.encrypt(data: data)
        let signedData = try hmacDataSignManager.sign(data: encryptedData)
        let fileURL = url.appendingPathComponent(filename)
        try signedData.write(to: fileURL)
    }
    
    func load(filename: String) throws -> Data {
        let fileURL = url.appendingPathComponent(filename)
        let signedData = try Data(contentsOf: fileURL)
        let privateKey = try secureEnclaveManager.getPrivateKey()
        let encryptedData = try hmacDataSignManager.validateHMAC(signedData: signedData)
        let decryptedData = try secureEnclaveManager.decrypt(encryptedData: encryptedData, privateKey: privateKey)
        return decryptedData
    }
    
}
