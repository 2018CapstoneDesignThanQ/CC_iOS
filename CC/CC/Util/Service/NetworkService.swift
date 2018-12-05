//
//  NetworkService.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 5..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import Foundation
import Alamofire

struct NetworkService: APIService, DecodingService {
    static let shared = NetworkService()
    
    enum RequestType {
        case getParametersRequest
        case request
    }
    
    let manager: SessionManager
    
    init() {
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        
        headers["Content-Type"] = "application/json"
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers
        manager = Alamofire.SessionManager(configuration: configuration)
        manager.adapter = AuthAdapter()
    }
    
    public func request(_ url: String,
                        method: HTTPMethod = .get,
                        parameters: Parameters? = nil,
                        headers: HTTPHeaders? = nil,
                        completion: @escaping (Result<Data>) -> Void) {
        var request: Alamofire.DataRequest?
        if method == .get && parameters != nil {
            request = self.connectRequest(url, requestType: .getParametersRequest,
                                          method: method, parameters: parameters, headers: headers)
        } else {
            request = self.connectRequest(url, requestType: .request,
                                          method: method, parameters: parameters, headers: headers)
        }
        
        request?.responseData { res in
            switch res.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let err):
                completion(.error(ErrorMessage.connetionError(err)))
            }
        }
    }
    
    private func connectRequest(_ url: String,
                                requestType: RequestType,
                                method: HTTPMethod,
                                parameters: Parameters? = nil,
                                headers: HTTPHeaders? = nil) -> Alamofire.DataRequest {
        var encoding: ParameterEncoding?
        switch requestType {
        case .getParametersRequest:
            encoding = URLEncoding.default
        case .request:
            encoding = JSONEncoding.default
        }
        
        return manager.request(url, method: method, parameters: parameters,
                               encoding: encoding ?? JSONEncoding.default, headers: headers)
    }
}
