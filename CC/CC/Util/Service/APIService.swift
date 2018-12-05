//
//  APIService.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 5..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import Foundation

// MAKR: - network result type
enum Result<T> {
    case success(T)
    case error(Error)
}

enum ErrorMessage: Error {
    case connetionError(Error)
    case parameterEncodeError(Error)
    case errorMessage(String)
}

// MAKR: - APIService : protocol for api
let baseURL: String = "http://13.125.184.252:3000/"

protocol APIService {}

extension APIService {
    func url(_ path: String) -> String {
        return baseURL + path
    }
}
