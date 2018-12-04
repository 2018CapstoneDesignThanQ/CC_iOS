//
//  TopMessageTableViewCell.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 4..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import UIKit

class TopMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    public func configure(_ index: Int, text: String) {
        self.indexLabel.text = "\(index)"
        self.messageLabel.text = text
    }
}
