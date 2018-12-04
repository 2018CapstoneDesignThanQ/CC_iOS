//
//  AskHomeViewController.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 4..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import UIKit

class AskHomeViewController: UIViewController {

    @IBOutlet weak var messagesTableView: UITableView!
    
    @IBOutlet var askMyThoughtView: UIView!
    
    var messages: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8]
    
    enum Section: Int, CaseIterable {
        case header
        case topMessageHeader
        case topMessage
        case messageHeader
    }
    
    enum MessageType: Int, CaseIterable {
        case message
        case answer
    }
    
    struct Const {
        static let headerHeight: CGFloat = 85.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableViewInit()
    }
    
    

}

extension AskHomeViewController: UITableViewDelegate {
    private func tableViewInit() {
        self.messagesTableView.delegate = self; self.messagesTableView.dataSource = self
        
        self.messagesTableView.register(MessageHeaderTableViewCell.self)
        self.messagesTableView.register(TopMessageTableViewCell.self)
        self.messagesTableView.register(MessageTableViewCell.self)
        self.messagesTableView.register(MessageAnswerTableViewCell.self)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = Section(rawValue: section) else { return UIView() }
        switch section {
        case .header:
            return self.askMyThoughtView
            
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = Section(rawValue: section) else { return 0 }
        switch section {
        case .header:
            return Const.headerHeight
            
        default:
            return 0
        }
    }
}

extension AskHomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count + self.messages.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            return MessageType.allCases.count
        }
        
        switch section {
        case .header:
            return 0
        case .topMessageHeader:
            return 1
        case .topMessage:
            return 3
        case .messageHeader:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            guard let row = MessageType(rawValue: indexPath.row) else { return UITableViewCell() }
            switch row {
            case .message:
                let cell = tableView.dequeue(MessageTableViewCell.self, for: indexPath)
                return cell
            case .answer:
                let cell = tableView.dequeue(MessageAnswerTableViewCell.self, for: indexPath)
                return cell
            }
        }
        switch section {
        case .header:
            return UITableViewCell()
        case .topMessageHeader,
             .messageHeader:
            let cell = tableView.dequeue(MessageHeaderTableViewCell.self, for: indexPath)
            cell.configure(section)
            return cell
        case .topMessage:
            let cell = tableView.dequeue(TopMessageTableViewCell.self, for: indexPath)
            cell.configure(indexPath.row + 1, text: "text")
            return cell
        }
    }
}
