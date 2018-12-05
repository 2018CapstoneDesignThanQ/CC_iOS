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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func setupUI() {
        let animationView = LOTAnimationView(name: "like")
        animationView.frame = self.lottieFrameView.frame
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = 0.6
        
        self.messageBackgroundView.addSubview(animationView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(setHeartAnimation(_:)))
        animationView.addGestureRecognizer(tap)
    }
    
    public func configure(_ index: Int, text: String) {
        self.indexLabel.text = "\(index)"
        self.messageLabel.text = text
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
