//
//  UIViewController+Loading.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 5..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import Foundation
import UIKit

enum LoadingState {
    case start
    case end
    
    func loading() {
        switch self {
        case .start:
            LoadingView.shared.isAnimating = true
        case .end:
            LoadingView.shared.isAnimating = false
        }
    }
}

extension UIViewController {
    func loading(_ state: LoadingState) {
        state.loading()
    }
}
