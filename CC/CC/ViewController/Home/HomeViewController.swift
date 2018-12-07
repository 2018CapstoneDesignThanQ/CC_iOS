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
    
    private var keyboardDismissGesture: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        self.textFieldInit()
        self.keyboardInit()
    }
    
    @IBAction func enterAction(_ sender: Any) {
        self.enterAction()
    }
    
    private func setupUI() {
        self.setTranslucentNavigation()
        
        self.codeEnterView.makeShadow()
    }
    
    private func enterAction() {
        if !(self.codeEnterTextField.text?.isEmpty ?? true) {
            let viewController = storyboard(.home).instantiateViewController(ofType: AskHomeViewController.self)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension HomeViewController: UITextFieldDelegate {
    private func textFieldInit() {
        self.codeEnterTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.enterAction()
        return true
    }
}


extension HomeViewController {
    private func keyboardInit() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func tapBackground(_ sender: UITapGestureRecognizer?) {
        self.codeEnterTextField.resignFirstResponder()
    }
    
    private func adjustKeyboardDismisTapGesture(isKeyboardVisible: Bool) {
        if isKeyboardVisible {
            if self.keyboardDismissGesture == nil {
                self.keyboardDismissGesture = UITapGestureRecognizer(target: self, action: #selector(tapBackground(_:)))
                if let gesture = self.keyboardDismissGesture {
                    self.view.addGestureRecognizer(gesture)
                }
            }
        } else {
            if let gesture = self.keyboardDismissGesture {
                self.view.removeGestureRecognizer(gesture)
                self.keyboardDismissGesture = nil
            }
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        self.adjustKeyboardDismisTapGesture(isKeyboardVisible: true)
        
        if self.view.frame.origin.y == 0 {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let keyboardHeight = keyboardSize.height
                let centerY = (self.view.frame.height - keyboardHeight)/2
                self.view.center.y = centerY
                view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.adjustKeyboardDismisTapGesture(isKeyboardVisible: false)
        
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
            view.layoutIfNeeded()
        }
    }
    
}
