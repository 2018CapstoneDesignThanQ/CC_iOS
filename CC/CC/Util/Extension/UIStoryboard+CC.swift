//
//  UIStoryboard+CC.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 3..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    func instantiateViewController<T>(ofType type: T.Type) -> T {
        return instantiateViewController(withIdentifier: String(describing: type)) as! T
    }
}

extension UIViewController {
    enum StoryboardType: String {
        case main = "Main"
        case sign = "Sign"
        case home = "Home"
        case noti = "Notification"
        case mypage = "MyPage"
    }
    
    func storyboard(_ type: StoryboardType) -> UIStoryboard {
        return UIStoryboard(name: type.rawValue, bundle: nil)
    }
}
