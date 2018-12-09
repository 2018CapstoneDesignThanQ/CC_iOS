//
//  ClassListTableViewCell.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 8..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class ClassListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var classNameLabel: UILabel!
    
    @IBOutlet weak var lottieFrameView: UIView!
    
    public var delegate: SendDataViewControllerDelegate?
    private var classId: String? = "1111"
    
    var animationView: LOTAnimationView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.classNameLabel.textColor = .pointYellow
            self.animationView?.isHidden = false
            self.animationView?.play() { (check) in
                if check {
                    self.delegate?.sendData(SendDataKey.selectedClassId,
                                            datatype: String.self, self.classId ?? "")
                }
            }
        } else {
            self.classNameLabel.textColor = .textGray
            self.animationView?.isHidden = true
            self.animationView?.stop()
        }
    }
    
    private func setupUI() {
        animationView = LOTAnimationView(name: "check_pop")
        animationView?.frame.size = self.lottieFrameView.frame.size
        animationView?.center = lottieFrameView.center
        self.layoutIfNeeded()
        animationView?.contentMode = .scaleAspectFill
        
        self.addSubview(self.animationView ?? LOTAnimationView())
    }
    
}

