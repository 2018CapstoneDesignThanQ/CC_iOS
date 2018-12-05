//
//  AuthAdapter.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 5..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import Foundation
import Alamofire

class AuthAdapter: RequestAdapter {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setValue(AuthService.shared.currentToken ?? "",
                            forHTTPHeaderField: "token")
        return urlRequest
    }
}
