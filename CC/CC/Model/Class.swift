//
//  Class.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 7..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import Foundation

struct Class: Codable {
    let message: String
    let classData: ClassData
    let questionData: [QuestionData]
}

struct ClassData: Codable {
    let classID, userFk: Int
    let title, content: String
    let regTime: Date
    let alertCnt: Int
    
    enum CodingKeys: String, CodingKey {
        case classID = "class_id"
        case userFk = "user_fk"
        case title, content
        case regTime = "reg_time"
        case alertCnt = "alert_cnt"
    }
}

struct QuestionData: Codable {
    let nickname: String
    var questionID, userFk, classFk: Int?
    let content: String
    let regTime: Date
    let likeCnt: Int?
    let isLike: Int
    
    enum CodingKeys: String, CodingKey {
        case nickname
        case questionID = "question_id"
        case userFk = "user_fk"
        case classFk = "class_fk"
        case content
        case regTime = "reg_time"
        case likeCnt = "like_cnt"
        case isLike = "is_like"
    }
}
