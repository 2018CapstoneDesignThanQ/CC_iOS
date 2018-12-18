//
//  MyPageService.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 17..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import Foundation

struct MyPageService: APIService, DecodingService {
    static let shared = MyPageService()
    
    public func getMyInfo(completion: @escaping (Result<MyPage>) -> Void) {
        NetworkService.shared.request(url("mypage")) { (result) in
            switch result {
            case .success(let data):
                completion(self.decodeJSONData(MyPage.self, data: data))
            case .error(let err):
                completion(.error(err))
            }
        }
    }
}
