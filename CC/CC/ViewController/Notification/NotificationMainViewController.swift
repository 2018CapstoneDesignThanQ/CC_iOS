//
//  NotificationMainViewController.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 3..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import UIKit

class NotificationMainViewController: UIViewController {

    @IBOutlet weak var alertView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }

    private func setupUI() {
        self.setTranslucentNavigation()
        
        self.alertView.makeShadow()
    }
}
