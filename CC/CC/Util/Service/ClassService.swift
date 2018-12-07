//
//  ClassService.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 7..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import Foundation

struct ClassService: APIService, DecodingService {
    static let shared = ClassService()
    
    public func getClass(roomId: String, completion: @escaping (Result<Class>) -> Void) {
        NetworkService.shared.request(url("class/room/\(roomId)")) { (result) in
            switch result {
            case .success(let data):
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                completion(self.decodeJSONData(Class.self, dateFormatter: formatter, data: data))
            case .error(let err):
                completion(.error(err))
            }
        }
    }
}
