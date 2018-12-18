//
//  SocketIOManager.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 6..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import Foundation
import SocketIO
import SwiftyJSON

class SocketIOManager: NSObject, DecodingService {
    static let shared = SocketIOManager()
    
    var manager: SocketManager = SocketManager(socketURL: URL(string: baseURL)!,
                                               config: [.log(true)])
    var socket: SocketIOClient?
    
    override init() {
        super.init()
        
        socket = manager.socket(forNamespace: "/room")
    }
    
    public func establishConnection() {
        socket?.connect()
    }
    
    public func closeConnection() {
        socket?.disconnect()
    }
    
    public func sendRoomID(_ roomId: String) {
        socket?.emit("getClassID", roomId)
    }
    
    public func getChatMessage(roomId: String, completion: @escaping (_ messageInfo: QuestionData) -> Void) {
        socket?.on("question") { (dataArr, socketAct) in
            let data = JSON(dataArr[0] as AnyObject)
//            let dataString = String(describing: data).data(using: .utf8)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            let message = QuestionData(nickname: data["nickname"].string ?? "",
                                       questionID: data["question"].int ?? -1,
                                       userFk: data["user"].int ?? 0,
                                       classFk: Int(roomId),
                                       content: data["content"].string ?? "",
                                       regTime: formatter.date(from: data["time"].string ?? "") ?? Date(),
                                       likeCnt: 0, isLike: 0)
            completion(message)
        }
    }
    
    public func getLikeAction(completion: @escaping (_ questionId: String, _ likeCount: Int) -> Void) {
        socket?.on("addLike") { (dataArr, socketAct) in
            let data = JSON(dataArr[0] as AnyObject)
            completion(data["question_id"].string ?? "", data["like_cnt"].int ?? 0)
        }
    }
    
    public func getTopMessage(completion: @escaping (_ messageInfo: Result<[QuestionData]>) -> Void) {
        socket?.on("top3") { (dataArr, socketAct) in
            print(1111111111)
            let json = JSON(dataArr[0] as AnyObject)
            guard let data = String(describing: json).data(using: .utf8) else { return }
            print(data)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            completion(self.decodeJSONData([QuestionData].self,
                                           dateFormatter: formatter, data: data))
        }
    }
}
