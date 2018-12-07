//
//  SocketIOManager.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 6..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    
//    var socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: "http://169.254.76.29:3000")!)
    var manager: SocketManager = SocketManager(socketURL: URL(string: "http://10.251.0.59:3000")!)
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
}
