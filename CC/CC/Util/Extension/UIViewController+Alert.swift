//
//  UIViewController+Alert.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 5..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func addAlert(_ type: UIAlertController.Style = .alert,
                  title: String, message: String,
                  actions: [UIAlertAction],
                  completion: (()->Swift.Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: type)
        
        for action in actions {
            alert.addAction(action)
        }
        
        self.present(alert, animated: true, completion: completion)
    }
}
