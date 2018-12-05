//
//  MessageTableViewCell.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 4..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import UIKit
import Lottie

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageBackgroundView: UIView!
    @IBOutlet weak var lottieFrameView: UIView!
    
    var animationView: LOTAnimationView?
    
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
    
    @objc
    private func setHeartAnimation(_ gesture: UITapGestureRecognizer) {
        if let view = gesture.view as? LOTAnimationView {
            if view.isAnimationPlaying {
                view.stop()
            } else {
                view.play()
            }
        }
    }
}
