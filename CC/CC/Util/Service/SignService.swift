//
//  SignService.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 5..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct SignService: APIService, DecodingService {
    static let shared = SignService()
    
    public func signUp(email: String, nickName: String, password: String,
                       completion: @escaping (Result<User>) -> Void) {
        let params = [
            "mail" : email,
            "nickname" : nickName,
            "password" : password
        ]
        
        NetworkService.shared.request(url("users/signup"),
                                      method: .post, parameters: params) { (result) in
            switch result {
            case .success(let data):
                completion(self.decodeJSONData(User.self, data: data))
            case .error(let err):
                completion(.error(err))
            }
        }
    }
    
    public func signIn(email: String, password: String,
                       completion: @escaping (Result<User>) -> Void) {
        let params = [
            "mail" : email,
            "password" : password
        ]
        
        NetworkService.shared.request(url("users/signin"),
                                      method: .post, parameters: params) { (result) in
            switch result {
            case .success(let data):
                completion(self.decodeJSONData(User.self, data: data))
            case .error(let err):
                completion(.error(err))
            }
        }
    }
}
