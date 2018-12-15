//
//  Heart.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 14..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import Foundation

struct Heart: Codable {
    let message: String
    let data: [QuestionData]
    
    enum CodingKeys: String, CodingKey {
        case message, data
    }
}
