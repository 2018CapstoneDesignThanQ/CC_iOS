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
    
    public weak var delegate: SendDataViewControllerDelegate?
    private var classId: String?
    
    var animationView: LOTAnimationView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print(animated)
        self.checkCurrentClass(selected: selected) { [weak self] in
            if !animated {
                self?.delegate?.sendData(SendDataKey.selectedClassId,
                                         datatype: String.self, self?.classId ?? "")
            }
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
    
    public func configure(_ data: ClassData, isCurrent: Bool) {
        self.classNameLabel.text = data.title
        self.classId = "\(data.classID)"
        self.checkCurrentClass(selected: isCurrent)
//        guard isCurrent else { return }
//        self.setSelected(isCurrent, animated: true)
    }
    
    public func checkCurrentClass(selected: Bool, completion: (() -> Void)? = nil) {
        if selected {
            self.classNameLabel.textColor = .pointYellow
            self.animationView?.isHidden = false
            self.animationView?.play() { (check) in
                if check {
                    completion?()
                }
            }
        } else {
            self.classNameLabel.textColor = .textGray
            self.animationView?.isHidden = true
            self.animationView?.stop()
        }
    }
    
}

