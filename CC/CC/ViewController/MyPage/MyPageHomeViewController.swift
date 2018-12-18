//
//  MyPageHomeViewController.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 17..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import UIKit

class MyPageHomeViewController: UIViewController {

    @IBOutlet weak var myPageTableView: UITableView!
    
    private var myProfile: MyPage?
    
    struct Const {
        static let myQuestionsCell = "MyQuestionsCell"
        static let myFavoriteQuestionsCell = "MyFavoriteQuestionsCell"
    }
    
    enum Section: Int, CaseIterable {
        case myProfile
        case myQuestion
        case myFavoriteQuestion
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        
        self.tableViewInit()
        
        self.setupData()
    }
    
    private func setupUI() {
        self.setTranslucentNavigation()
    }
    
    private func setupData() {
        MyPageService.shared.getMyInfo { (result) in
            switch result {
            case .success(let data):
                self.myProfile = data
                self.myPageTableView.reloadData()
            case .error(let err):
                self.errorAction(error: err, confirmAction: nil)
            }
        }
    }
    
}

extension MyPageHomeViewController: UITableViewDelegate {
    private func tableViewInit() {
        self.myPageTableView.delegate = self; self.myPageTableView.dataSource = self
        
        self.myPageTableView.tableFooterView = UIView(frame: .zero)
    }
}

extension MyPageHomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .myProfile:
            let cell = tableView.dequeue(MyProfileTableViewCell.self, for: indexPath)
            cell.configure(self.myProfile?.data.nickname ?? "")
            return cell
        case .myQuestion:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Const.myQuestionsCell) else { return UITableViewCell() }
            return cell
        case .myFavoriteQuestion:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Const.myFavoriteQuestionsCell) else { return UITableViewCell() }
            return cell
        }
    }
}
