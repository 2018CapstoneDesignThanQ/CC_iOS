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
    
    public func sendRoomID() {
        socket?.emit("getClassID", "3349")
    }
    
    public func getChatMessage(completion: @escaping (_ messageInfo: JSON) -> Void) {
        socket?.on("question") { (dataArr, socketAct) in
            print(dataArr)
            let data = dataArr[0] as AnyObject
            completion(JSON(data))
        }
    }
    
}
