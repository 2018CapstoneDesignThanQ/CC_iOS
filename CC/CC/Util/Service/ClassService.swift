//
//  ClassService.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 7..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import Foundation
import SwiftyJSON
import KeychainAccess

class ClassService: APIService, DecodingService {
    static let shared = ClassService()
    
    var lastRoomId: String?
    private let keychain = Keychain(service: "com.hyejin.tlend")
    
    init() {
        self.lastRoomId = self.loadRoomId()
    }
    
    private func loadRoomId() -> String? {
        guard let roomId = self.keychain["roomID"] else { return nil }
        return roomId
    }
    
    public func saveRoomId(_ roomId: String) throws {
        try self.keychain.set(roomId, key: "roomID")
        self.lastRoomId = self.loadRoomId()
    }
    
    public func removeRoomId() throws {
        try self.keychain.remove("token")
        self.lastRoomId = nil
    }
    
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
    
    public func sendMessageAtClass(roomId: String, content: String, completion: @escaping (Result<String>) -> Void) {
        let params = [
            "content" : content
        ]
        NetworkService.shared.request(url("class/room/\(roomId)/question"), method: .post, parameters: params) { (result) in
            switch result {
            case .success(let data):
                completion(.success(JSON(data).string ?? ""))
            case .error(let err):
                completion(.error(err))
            }
        }
    }
    
    public func sendLikeAction(roomId: String, questionId: String,
                               completion: @escaping (Result<String>) -> Void) {
        let params = [
            "class_id" : roomId,
            "question_id" : questionId
        ]
        
        NetworkService.shared.request(url("question/like"), method: .post, parameters: params) { (result) in
            switch result {
            case .success(let data):
//                let formatter = DateFormatter()
//                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//                completion(self.decodeJSONData(Heart.self, dateFormatter: formatter, data: data))
                completion(.success(JSON(data)["message"].string ?? ""))
            case .error(let err):
                completion(.error(err))
            }
        }
    }
    
    public func sendDislikeAction(roomId: String, questionId: String,
                               completion: @escaping (Result<String>) -> Void) {
        let params = [
            "class_id" : roomId,
            "question_id" : questionId
        ]
        
        NetworkService.shared.request(url("question/like"), method: .patch, parameters: params) { (result) in
            switch result {
            case .success(let data):
                completion(.success(JSON(data)["message"].string ?? ""))
            case .error(let err):
                completion(.error(err))
            }
        }
    }
    
    public func getMyClasses(completion: @escaping (Result<MyClass>) -> Void) {
        NetworkService.shared.request(url("mypage/class")) { (result) in
            switch result {
            case .success(let data):
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                completion(self.decodeJSONData(MyClass.self, dateFormatter: formatter, data: data))
            case .error(let err):
                completion(.error(err))
            }
        }
    }
}
