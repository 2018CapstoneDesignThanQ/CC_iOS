//
//  TopMessageTableViewCell.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 4..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import UIKit
import Lottie

class TopMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageBackgroundView: UIView!
    @IBOutlet weak var lottieFrameView: UIView!
    
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    private var animationView: LOTAnimationView?
    private var isLike: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func setupUI() {
        animationView = LOTAnimationView(name: "like")
        animationView?.frame = self.lottieFrameView.frame
        animationView?.contentMode = .scaleAspectFill
        animationView?.animationSpeed = 0.6
        
        self.messageBackgroundView.addSubview(self.animationView ?? LOTAnimationView())
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(setHeartAnimation(_:)))
        animationView?.addGestureRecognizer(tap)
    }
    
    public func configure(_ index: Int, data: QuestionData) {
        self.animationView?.isHidden = true
        
        self.indexLabel.text = "\(index)"
        
        self.messageLabel.text = data.content
        self.isLike = data.isLike != 0
        self.heartInit(self.isLike)
    }
    
    public func setSearchText(_ text: String) {
        self.messageLabel.setLabelMultiColor(.teal, size: 14.0, change: text)
    }
    
    private func heartInit(_ isLike: Bool) {
        if isLike {
            self.animationView?.play()
        } else {
            self.animationView?.stop()
        }
    }
    
    @objc
    private func setHeartAnimation(_ gesture: UITapGestureRecognizer) {
        self.isLike = !self.isLike
        self.heartInit(self.isLike)
    }
}
