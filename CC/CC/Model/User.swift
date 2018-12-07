//
//  User.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 7..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import Foundation

struct User: Codable {
    let message: String
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case message, token
    }
}
