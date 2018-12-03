//
//  LoginHomeViewController.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 3..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

class LoginHomeViewController: UIViewController {

    @IBOutlet var textFields: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }
    
    @IBAction func signinAction(_ sender: Any) {
        let tabBarController = storyboard(.main).instantiateViewController(ofType: RAMAnimatedTabBarController.self)
        tabBarController.setSelectIndex(from: 0, to: 1)
        self.present(tabBarController, animated: true, completion: nil)
    }
    
    private func setupUI() {
        self.setTranslucentNavigation()
    }

}
