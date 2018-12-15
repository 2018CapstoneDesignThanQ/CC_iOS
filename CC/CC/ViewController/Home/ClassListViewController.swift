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
    
    public var roomId: String?
    private var myClasses: [ClassData] = []
    
    public weak var delegate: SendDataViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewInit()
        
        self.setupData()
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addClassAction(_ sender: Any) {
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
