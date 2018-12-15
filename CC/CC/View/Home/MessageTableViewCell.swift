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
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var lottieFrameView: UIView!
    
    public var index: Int?
    
    private var animationView: LOTAnimationView?
    private var isLike: Bool = false
    
    public weak var delegate: SendDataViewControllerDelegate?
    
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
    
    public func configure(_ data: QuestionData) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
        self.dateLabel.text = formatter.string(from: data.regTime)
        self.contentsLabel.text = data.content
        self.likeCountLabel.text = "\(data.likeCnt ?? 0)"
        
        self.isLike = data.isLike != 0
        self.heartInit(self.isLike)
    }
    
    public func setSearchText(_ text: String) {
        self.contentsLabel.setLabelMultiColor(.pointYellow, size: 12.0, change: text)
    }
    
    private func heartInit(_ isLike: Bool) {
        if isLike {
//            self.animationView?.animationProgress = 1.0
            self.animationView?.play()
            self.likeCountLabel.textColor = .heartRed
        } else {
            self.animationView?.stop()
            self.likeCountLabel.textColor = .heartGray
        }
    }
    
    @objc
    private func setHeartAnimation(_ gesture: UITapGestureRecognizer) {
        self.isLike = !self.isLike
        
        if self.isLike {
            self.animationView?.play()
            self.likeCountLabel.textColor = .heartRed
            delegate?.sendData(SendDataKey.selectLike,
                               datatype: Int.self, self.index ?? 0)
        } else {
            self.animationView?.stop()
            self.likeCountLabel.textColor = .heartGray
            delegate?.sendData(SendDataKey.selectDislike,
                               datatype: Int.self, self.index ?? 0)
        }
    }
}
