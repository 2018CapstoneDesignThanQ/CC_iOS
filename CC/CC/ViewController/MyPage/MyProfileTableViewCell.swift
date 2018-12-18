//
//  MyProfileTableViewCell.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 17..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import UIKit

class MyProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var nickNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    public func configure(_ data: String) {
        self.nickNameLabel.text = data
    }

}
