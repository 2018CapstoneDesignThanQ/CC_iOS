//
//  UIView+CC.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 3..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get{
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let borderColor = layer.borderColor else { return nil }
            return UIColor(cgColor: borderColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @discardableResult func roundCorner() -> UIView {
        self.cornerRadius = self.bounds.size.width / 2
        return self
    }
}
