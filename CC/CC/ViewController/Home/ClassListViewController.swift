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
    
    public var delegate: SendDataViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableViewInit()
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addClassAction(_ sender: Any) {
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(ClassListTableViewCell.self, for: indexPath)
        cell.delegate = self
        return cell
    }
}
