//
//  UIView+Shadow.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 3..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func makeShadow(_ color: UIColor = UIColor.black,
                    opacity: Float = 0.3,
                    size offset: CGSize = CGSize(width: 0, height: 3),
                    blur radius: CGFloat = 6) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
    }
}
