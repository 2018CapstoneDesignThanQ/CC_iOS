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
    
    private var keyboardDismissGesture: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        
        self.textFieldInit()
        self.keyboardInit()
    }
    
    @IBAction func signinAction(_ sender: Any) {
        self.signinAction()
    }
    
    private func setupUI() {
        self.setTranslucentNavigation()
    }
    
    private func signinAction() {
        for textField in textFields {
            textField.resignFirstResponder()
            
            if textField.text?.isEmpty ?? true {
                addAlert(title: "로그인 오류",
                         message: "모든 항목을 채워주세요 :(",
                         actions: [UIAlertAction(title: "확인", style: .default, handler: nil)],
                         completion: nil)
            } else if textField == textFields.last &&
                !(textField.text?.isEmpty ?? true) {
                self.signinNetwork()
                loading(.start)
            }
        }
    }

    private func signinNetwork() {
        SignService.shared.signIn(email: self.textFields[0].text ?? "",
                                  password: self.textFields[1].text ?? "") { [weak self] (result) in
                                    switch result {
                                    case .success(let data):
                                        try? AuthService.shared.saveToken(data.token)
                                        self?.signinMessageAction(data.message)
                                        self?.loading(.end)
                                    case .error(let err):
                                        self?.errorAction(error: err,
                                                         confirmAction: nil) { [weak self] (message) in
                                            self?.signinMessageAction(message)
                                        }
                                        self?.loading(.end)
                                    }
        }
    }
    
    private func signinMessageAction(_ message: String) {
        if message == "Success To Sign Up" {
            let tabBarController = self.storyboard(.main).instantiateViewController(ofType: RAMAnimatedTabBarController.self)
            tabBarController.setSelectIndex(from: 0, to: 1)
            
            if ClassService.shared.lastRoomId != nil {
                guard let naviController = tabBarController.viewControllers?[1] as? UINavigationController else { return }
                let viewController = storyboard(.home).instantiateViewController(ofType: AskHomeViewController.self)
                viewController.roomId = ClassService.shared.lastRoomId
                naviController.setViewControllers([viewController], animated: true)
            }
            
            self.present(tabBarController, animated: true, completion: nil)
            
        } else if message == "Fail To Sign In" {
            addAlert(title: "로그인 오류",
                     message: "이메일 또는 패스워드를 확인해주세요!",
                     actions: [UIAlertAction(title: "확인", style: .default, handler: nil)],
                     completion: nil)
        } else {
            print(message)
        }
    }
}

extension LoginHomeViewController: UITextFieldDelegate {
    private func textFieldInit() {
        for textField in textFields {
            textField.delegate = self
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard var index = textFields.index(where: { $0 == textField }) else { return true }
        index += 1
        if index == textFields.endIndex {
            self.signinAction()
        } else {
            textFields[index].becomeFirstResponder()
        }
        return true
    }
}

extension LoginHomeViewController {
    private func keyboardInit() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func tapBackground(_ sender: UITapGestureRecognizer?) {
        for textField in textFields {
            textField.resignFirstResponder()
        }
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

