//
//  SecretsStash.swift
//  CategorySwiper
//
//  Created by Tana Vora on 1/21/25.
//

import Foundation
import SimpleKeychain

struct SecretsStash {
    private var keychain: SimpleKeychain
    
    init() {
        // Apple recommends setting this to TRUE unless you must use the legacy macOS Keychain
        // https://developer.apple.com/documentation/security/ksecusedataprotectionkeychain
        let attributes = [kSecUseDataProtectionKeychain as String: true]
        
        self.keychain = SimpleKeychain(attributes: attributes)
    }
    
    func delete(key: String) throws {
        try keychain.deleteItem(forKey: key)
    }
    
    func recall(key: String) throws -> String {
        return try keychain.string(forKey: key)
    }
    
    func save(key: String, value: String) throws {
        try keychain.set(value, forKey: key)
    }
}
