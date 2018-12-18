//
//  MyPage.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 17..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import Foundation

struct MyPage: Codable {
    let message: String
    let data: UserData
}

struct UserData: Codable {
    let userID: Int
    let nickname: String
    let userImg: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nickname
        case userImg = "user_img"
    }
}
