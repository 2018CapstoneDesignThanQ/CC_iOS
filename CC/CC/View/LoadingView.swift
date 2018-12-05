//
//  LoadingView.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 5..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class LoadingView: UIView {
    static let shared = LoadingView()
    
    private var indicatorView: UIView = UIView()
    var animationView: LOTAnimationView?
    
    struct Style {
        static let indicatorViewColor: UIColor = .clear
        static let indicatorViewSize: CGSize = CGSize(width: 80.0, height: 80.0)
        static let indicatorViewCornerRadius: CGFloat = 9.0
        
        static let indicatorSize: CGSize = CGSize(width: 128.0, height: 128.0)
    }
    
    var isAnimating: Bool = false {
        didSet {
            switch self.isAnimating {
            case true:
                self.animationView?.play()
                self.isHidden = false
                
            case false:
                self.animationView?.stop()
                self.isHidden = true
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }
    
    private func setupUI() {
        self.frame = UIScreen.main.bounds
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.75)
        self.isHidden = true
        
        self.indicatorView.layer.backgroundColor = Style.indicatorViewColor.cgColor
        self.indicatorView.layer.frame.size = Style.indicatorViewSize
        self.indicatorView.cornerRadius = Style.indicatorViewCornerRadius
        
        self.indicatorView.center = self.center
        
        let centerXY: CGFloat = Style.indicatorViewSize.width/2
        
        animationView = LOTAnimationView(name: "loading2")
        guard let indicator = self.animationView else { return }
        indicator.frame.size = Style.indicatorSize
        indicator.center = CGPoint(x: centerXY, y: centerXY)
        indicator.contentMode = .scaleAspectFill
        indicator.loopAnimation = true
        
        self.indicatorView.addSubview(indicator)
        
        self.addSubview(self.indicatorView)
        
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        keyWindow.addSubview(self)
    }
}
