//
//  SignUpViewController.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 3..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

class SignUpViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet var textFieldBottomViews: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        
        self.textFieldInit()
    }
    
    @IBAction func signupAction(_ sender: Any) {
        self.signupAction()
    }
    
    private func setupUI() {
        self.setTranslucentNavigation()
        
        self.titleLabel.setLabelMultiColor(.pointYellow, weight: .heavy, size: 16.0, change: "cc")
    }
    
    private func signupAction() {
        for textField in textFields {
            if textField.text?.isEmpty ?? true {
                addAlert(title: "로그인 오류", message: "모든 항목을 채워주세요!",
                         actions: [UIAlertAction(title: "확인", style: .default, handler: nil)],
                         completion: nil)
            } else if textField == textFields.last &&
                !(textField.text?.isEmpty ?? true) {
                if textFields[1].text != textFields[2].text {
                    addAlert(title: "로그인 오류", message: "비밀번호를 확인해주세요.",
                             actions: [UIAlertAction(title: "확인", style: .default, handler: nil)],
                             completion: nil)
                } else {
                    self.signupNetwork()
                    loading(.start)
                }
            }
        }
    }
    
    private func signupNetwork() {
        SignService.shared.signUp(email: textFields[0].text ?? "",
                                  nickName: textFields[3].text ?? "",
                                  password: textFields[1].text ?? "") { [weak self] (result) in
                                    switch result {
                                    case .success(let data):
                                        self?.signupMessageAction(data)
                                        self?.loading(.end)
                                    case .error(let err):
                                        self?.errorAction(error: err, confirmAction: nil)
                                        self?.loading(.end)
                                    }
        }
    }
    
    private func signupMessageAction(_ message: String) {
        if message == "Success To Sign Up" {
            let tabBarController = self.storyboard(.main).instantiateViewController(ofType: RAMAnimatedTabBarController.self)
            tabBarController.setSelectIndex(from: 0, to: 1)
            self.present(tabBarController, animated: true, completion: nil)
            
        } else if message == "Duplicate Mail" {
            addAlert(title: "로그인 오류",
                     message: "이미 존재하는 이메일 입니다 :(",
                     actions: [UIAlertAction(title: "확인", style: .default, handler: nil)],
                     completion: nil)
        } else {
            print(message)
        }
    }
}

extension SignUpViewController: UITextFieldDelegate {
    private func textFieldInit() {
        for textfield in textFields {
            textfield.delegate = self
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.resetBottomView()
        
        let index = textFields.index { $0 == textField }
        textFieldBottomViews[index ?? 0].backgroundColor = .pointYellow
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard var index = textFields.index(where: { $0 == textField }) else { return true }
        index += 1
        if index == textFields.endIndex {
            self.signupAction()
        } else {
            textFields[index].becomeFirstResponder()
        }
        return true
    }
    
    private func resetBottomView() {
        for view in textFieldBottomViews {
            view.backgroundColor = .white
        }
    }
}
