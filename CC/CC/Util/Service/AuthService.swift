//
//  AuthService.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 5..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import Foundation
import KeychainAccess

protocol APIServiceType {
    var currentToken: String? { get }
}

class AuthService: APIServiceType {
    
    static let shared = AuthService()
    
    var currentToken: String?
    private let keychain = Keychain(service: "com.hyejin.tlend")
    
    init() {
        self.currentToken = self.loadToken()
    }
    
    private func loadToken() -> String? {
        guard let token = self.keychain["token"] else { return nil }
        return token
    }
    
    public func saveToken(_ token: String) throws {
        try self.keychain.set(token, key: "token")
        self.currentToken = self.loadToken()
    }
    
    public func removeToken() throws {
        try self.keychain.remove("token")
        self.currentToken = nil
    }
}
