//
//  UIViewController+NetworkError.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 5..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    public func errorAction(error: Error,
                            confirmAction: ((UIAlertAction) -> Void)?,
                            completion: ((String) -> Void)? = nil) {
        let confirm = UIAlertAction(title: "확인", style: .default, handler: confirmAction)
        
        switch error {
        case ErrorMessage.connetionError(let err):
            print(err.localizedDescription)
            self.addAlert(title: "네트워킹 오류", message: "연결 상태를 확인해주세요. :(",
                          actions: [confirm], completion: nil)
        case ErrorMessage.parameterEncodeError(let err):
            print(err.localizedDescription)
            self.addAlert(title: "네트워킹 오류", message: "디코딩 오류",
                          actions: [confirm], completion: nil)
        case ErrorMessage.errorMessage(let msg):
            print(msg)
            completion?(msg)
            
        default:
            print(error)
            self.addAlert(title: "네트워킹 오류", message: error.localizedDescription,
                          actions: [confirm], completion: nil)
        }
    }
}
