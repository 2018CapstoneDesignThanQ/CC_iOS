//
//  SignUpViewController.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 3..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }
    
    private func setupUI() {
        self.setTranslucentNavigation()
        
        self.titleLabel.setLabelMultiColor(.pointYellow, weight: .heavy, size: 16.0, change: "cc")
    }


}
