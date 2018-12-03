//
//  UIViewController+Navigationbar.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 3..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func setTranslucentNavigation() {
        guard let navi = self.navigationController?.navigationBar else { return }
        navi.setBackgroundImage(UIImage(), for: .default)
        navi.shadowImage = UIImage()
        navi.isTranslucent = true
    }
}
