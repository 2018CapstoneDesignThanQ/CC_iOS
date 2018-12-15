//
//  SendDataViewControllerDelegate.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 9..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import Foundation

protocol SendDataViewControllerDelegate: class {
    func sendData<T>(_ key: String, datatype: T.Type, _ data: T)
}

struct SendDataKey {
    static let selectedClassId: String = "com.hyejin.sendData.classId"
    static let selectLike: String = "com.hyejin.sendData.like"
    static let selectDislike: String = "com.hyejin.sendData.dislike"
}
