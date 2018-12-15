//
//  ClassListViewController.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 8..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import UIKit

class ClassListViewController: UIViewController {

    @IBOutlet weak var classListTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var codeEnterTextField: UITextField!
    
    public var roomId: String?
    private var myClasses: [ClassData] = []
    
    private var keyboardDismissGesture: UITapGestureRecognizer?
    
    public weak var delegate: SendDataViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewInit()
        self.keyboardInit()
        
        self.setupData()
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addClassAction(_ sender: Any) {
        if !(self.codeEnterTextField.text?.isEmpty ?? true) {
            self.dismiss(animated: true, completion: nil)
            delegate?.sendData(SendDataKey.selectedClassId,
                               datatype: String.self, self.codeEnterTextField.text ?? "")
        }
    }
    
    private func setupData() {
        ClassService.shared.getMyClasses { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success(let data):
                self.myClasses = data.applyClass
                self.classListTableView.reloadData()
                self.tableViewHeightConstraint.constant = self.classListTableView.contentSize.height
                
                for (index, myClass) in self.myClasses.enumerated()
                    where myClass.classID == Int(self.roomId ?? "") {
                        let indexPath = IndexPath(row: index, section: 0)
                        self.classListTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                }
                
            case .error(let err):
                self.errorAction(error: err, confirmAction: nil)
            }
        }
    }
}

extension ClassListViewController: SendDataViewControllerDelegate {
    func sendData<T>(_ key: String, datatype: T.Type, _ data: T) {
        if key == SendDataKey.selectedClassId {
            guard let data = data as? String else { return }
            
            self.dismiss(animated: true, completion: nil)
            delegate?.sendData(SendDataKey.selectedClassId,
                               datatype: String.self, data)
        }
    }
}

extension ClassListViewController: UITableViewDelegate {
    private func tableViewInit() {
        self.classListTableView.delegate = self; self.classListTableView.dataSource = self
        
        self.classListTableView.register(ClassListTableViewCell.self)
    }
}

extension ClassListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myClasses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(ClassListTableViewCell.self, for: indexPath)
        let myClass = self.myClasses[indexPath.row]
        cell.configure(myClass, isCurrent: myClass.classID == Int(self.roomId ?? ""))
        cell.delegate = self
        return cell
    }
}

extension ClassListViewController {
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
