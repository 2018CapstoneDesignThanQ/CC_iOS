//
//  AskViewController.swift
//  
//
//  Created by 이혜진 on 2018. 12. 7..
//

import UIKit

class AskViewController: UIViewController {

    @IBOutlet weak var questionTextView: UITextView!
    
    @IBOutlet weak var sendButtonBottomConstraint: NSLayoutConstraint!
    
    private var keyboardDismissGesture: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        
        self.textViewInit()
        self.keyboardInit()
    }

    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupUI() {
        setTranslucentNavigation()
//        cancelTranslucentNavigation()
        
        textViewDidEndEditing(self.questionTextView)
    }
}

extension AskViewController: UITextViewDelegate {
    private func textViewInit() {
        self.questionTextView.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .textLightGray {
            textView.text = ""
            textView.textColor = .textGray
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = "Type you question"
            textView.textColor = .textLightGray
            
        }
    }
}

extension AskViewController {
    private func keyboardInit() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func tapBackground(_ sender: UITapGestureRecognizer?) {
        self.questionTextView.resignFirstResponder()
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
        
//        if self.sendButtonBottomConstraint.constant == 0 {
//            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//                let keyboardHeight = keyboardSize.height
//                self.sendButtonBottomConstraint.constant = -(keyboardHeight)
//                view.layoutIfNeeded()
//            }
//        }
        
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
        
//        if self.sendButtonBottomConstraint.constant != 0 {
//            self.sendButtonBottomConstraint.constant = 0
//            view.layoutIfNeeded()
//        }
        
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
            view.layoutIfNeeded()
        }
    }
    
}

