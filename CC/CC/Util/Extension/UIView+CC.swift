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
    public enum RoundType: Int {
        case none
        case widthRound
        case heightRound
    }
    
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
    
    @IBInspectable var roundType: Int {
        get {
            return 0
        }
        set {
            guard let type = RoundType(rawValue: newValue) else { return }
            switch type {
            case .none:
                break
            case .widthRound:
                self.cornerRadius = self.bounds.size.width / 2
            case .heightRound:
                self.cornerRadius = self.bounds.size.height / 2
            }
        }
    }
    
    @discardableResult func roundCorner() -> UIView {
        self.cornerRadius = self.bounds.size.width / 2
        return self
    }
    
    private func setupUI() {
        guard let type = RoundType(rawValue: self.roundType) else { return }
        switch type {
        case .none:
            break
        case .widthRound:
            self.cornerRadius = self.bounds.size.width / 2
        case .heightRound:
            self.cornerRadius = self.bounds.size.height / 2
        }
    }
}
