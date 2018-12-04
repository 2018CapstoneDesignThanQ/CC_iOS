//
//  MessageHeaderTableViewCell.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 4..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import UIKit

class MessageHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var messageHeaderView: UIView!
    @IBOutlet weak var messageHeaderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    public func configure(_ type: AskHomeViewController.Section) {
        switch type {
        case .topMessageHeader:
            self.messageHeaderView.backgroundColor = .teal
            self.messageHeaderLabel.textColor = .white
            self.messageHeaderLabel.text = "TOP  ▼"
        case .messageHeader:
            self.messageHeaderView.backgroundColor = .white
            self.messageHeaderLabel.textColor = .teal
            self.messageHeaderLabel.text = "LIVE"
            
        default:
            break
        }
    }
}
