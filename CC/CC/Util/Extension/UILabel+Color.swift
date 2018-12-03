//
//  UILabel+Color.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 3..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    public func setLabelMultiColor(_ color: UIColor = .yellow,
                                   weight: UIFont.Weight = .bold,
                                   size: CGFloat,
                                   change text: String) {
        guard let string = self.text else { return }
        
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: string)
        attributedString.setColorForText(textForAttribute: text, withColor: color)
        self.font = UIFont.systemFont(ofSize: size, weight: weight)
        self.attributedText = attributedString
    }
}

extension NSMutableAttributedString {
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
}
