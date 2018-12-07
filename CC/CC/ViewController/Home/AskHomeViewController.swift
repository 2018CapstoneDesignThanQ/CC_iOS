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
    
    public var roomId: String?
    
    private var classData: ClassData?
    private var messages: [QuestionData] = []
    
    enum Section: Int, CaseIterable {
        case header
        case topMessageHeader
        case topMessage
        case messageHeader
        case message
    }
    
    enum MessageType: Int, CaseIterable {
        case message
        case answer
    }
    
    struct Const {
        static let headerHeight: CGFloat = 90.0
        
        static let navi: String = "goAskQuestionNavi"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableViewInit()
        self.setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupUI()
    }
    
    @IBAction func goShareMyThoughtAction(_ sender: Any) {
//        if let naviController = storyboard(.home).instantiateViewController(withIdentifier: Const.navi) as? UINavigationController {
//            self.present(naviController, animated: true, completion: nil)
//        }
        let viewController = storyboard(.home).instantiateViewController(ofType: AskViewController.self)
        viewController.roomId = self.roomId
        self.present(viewController, animated: true, completion: nil)
    }
    
    private func setupUI() {
        self.setTranslucentNavigation()
    }
    
    private func setupData() {
        loading(.start)
        self.getClassNetwork()
        SocketIOManager.shared.sendRoomID()
        SocketIOManager.shared.getChatMessage() { [weak self] result in
            DispatchQueue.main.async {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                let message = QuestionData(nickname: result["nickname"].string ?? "",
                                           questionID: nil,
                                           userFk: result["user"].int ?? 0,
                                           classFk: Int(self?.roomId ?? ""),
                                           content: result["content"].string ?? "",
                                           regTime: formatter.date(from: result["time"].string ?? "") ?? Date(),
                                           likeCnt: 0, isLike: 0)
                self?.messages.append(message)
                self?.messagesTableView.reloadData()
            }
        }
    }
    
    private func getClassNetwork() {
        ClassService.shared.getClass(roomId: self.roomId ?? "") { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success(let data):
                try? ClassService.shared.saveRoomId(self.roomId ?? "")
                
                self.classData = data.classData
                self.navigationItem.title = data.classData.title
                self.messages = data.questionData
                self.messagesTableView.reloadData()
                
                self.navigationController?.setViewControllers([self], animated: true)
                self.loading(.end)
            case .error(let err):
                self.errorAction(error: err, confirmAction: nil) { [weak self] (message) in
                    self?.getClassMessageAction(message)
                }
                self.loading(.end)
            }
        }
    }
    
    private func getClassMessageAction(_ message: String) {
        if message == "This Class  Does Not Exist" {
            self.addAlert(title: "",
                           message: "코드가 유효하지 않습니다.",
                           actions: [UIAlertAction(title: "확인", style: .default, handler: { (_) in
                            self.navigationController?.popViewController(animated: true)
                           })], completion: nil)
        }
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
//            return MessageType.allCases.count
            return 0
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
        case .message:
            return self.messages.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
//            guard let row = MessageType(rawValue: indexPath.row) else { return UITableViewCell() }
//            switch row {
//            case .message:
//                let cell = tableView.dequeue(MessageTableViewCell.self, for: indexPath)
//                return cell
//            case .answer:
//                let cell = tableView.dequeue(MessageAnswerTableViewCell.self, for: indexPath)
//                return cell
//            }
            return UITableViewCell()
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
        case .message:
            let cell = tableView.dequeue(MessageTableViewCell.self, for: indexPath)
            let index = self.messages.count - indexPath.row - 1
            cell.configure(self.messages[index])
            return cell
        }
    }
}
