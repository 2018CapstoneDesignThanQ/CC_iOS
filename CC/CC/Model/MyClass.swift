//
//  MyClass.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 15..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import Foundation

struct MyClass: Codable {
    let applyClass: [ClassData]
    
    enum CodingKeys: String, CodingKey {
        case applyClass = "apply_class"
    }
}
