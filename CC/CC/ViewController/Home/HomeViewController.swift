//
//  HomeViewController.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 3..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var codeEnterView: UIView!
    @IBOutlet weak var codeEnterTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    @IBAction func enterAction(_ sender: Any) {
        let viewController = storyboard(.home).instantiateViewController(ofType: AskHomeViewController.self)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func setupUI() {
        self.setTranslucentNavigation()
        
        self.codeEnterView.makeShadow()
    }
}
