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
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var searchBarTopConstraint: NSLayoutConstraint!
    
    public var roomId: String?
    private var preRoomId: String?
    
    private var classData: ClassData?
    private var topMessages: [QuestionData] = []
    private var messages: [QuestionData] = []
    
    private var topMessagesForShow: [QuestionData] = []
    private var messagesForShow: [QuestionData] = []
    private var searchText: String?
    private var keyboardDismissGesture: UITapGestureRecognizer?
    
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
        static let headerHeight: CGFloat = 85.0
        
        static let navi: String = "goAskQuestionNavi"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchBarInit()
        self.tableViewInit()
        self.setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupUI()
    }
    
    @IBAction func goShareMyThoughtAction(_ sender: Any) {
        let viewController = storyboard(.home).instantiateViewController(ofType: AskViewController.self)
        viewController.roomId = self.roomId
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func showClassListAction(_ sender: Any) {
        let viewController = storyboard(.home).instantiateViewController(ofType: ClassListViewController.self)
        viewController.delegate = self
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func pressedSearchButtonAction(_ sender: Any) {
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let active = self?.searchBarTopConstraint.isActive else { return }
            self?.searchBarTopConstraint.isActive = !active
            
            self?.searchBar.text = ""
            self?.searchBar(self?.searchBar ?? UISearchBar(), textDidChange: "")
            self?.searchBar.resignFirstResponder()
            
            self?.view.layoutIfNeeded()
        }
    }
    
    private func setupUI() {
        self.setTranslucentNavigation()
        
        self.searchBar.backgroundImage = UIImage()
        self.searchBarTopConstraint.isActive = false
    }
    
    private func setupData() {
        loading(.start)
        self.getClassNetwork()
    }
    
    private func getClassNetwork() {
        ClassService.shared.getClass(roomId: self.roomId ?? "") { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success(let data):
                try? ClassService.shared.saveRoomId(self.roomId ?? "")
                
                self.classData = data.classData
                self.navigationItem.title = data.classData.title
                self.topMessages = data.topQuestion
                self.messages = data.questionData
                
                self.topMessagesForShow = self.topMessages
                self.messagesForShow = self.messages
                
                self.messagesTableView.reloadData()
                
                self.navigationController?.setViewControllers([self], animated: true)
                
                self.setClassSocket()
                self.loading(.end)
            case .error(let err):
                self.errorAction(error: err, confirmAction: nil) { [weak self] (message) in
                    self?.getClassMessageAction(message)
                }
                self.loading(.end)
            }
        }
    }
    
    private func setClassSocket() {
        SocketIOManager.shared.sendRoomID(self.roomId ?? "")
        SocketIOManager.shared.getChatMessage() { [weak self] result in
            DispatchQueue.main.async {
                print(result)
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
                self?.messagesForShow.append(message)
//                self?.messagesTableView.reloadData()
                self?.messagesTableView.reloadSections(IndexSet(integer: Section.message.rawValue),
                                                       with: .automatic)
            }
        }
    }
    
    private func getClassMessageAction(_ message: String) {
        if message == "This Class  Does Not Exist" {
            self.addAlert(title: "",
                           message: "코드가 유효하지 않습니다.",
                           actions: [UIAlertAction(title: "확인", style: .default, handler: { (_) in
                            self.navigationController?.popViewController(animated: true)
                            self.roomId = self.preRoomId
                           })], completion: nil)
        }
    }
}

extension AskHomeViewController: SendDataViewControllerDelegate {
    func sendData<T>(_ key: String, datatype: T.Type, _ data: T) {
        if key == SendDataKey.selectedClassId {
            guard let data = data as? String else { return }
            self.preRoomId = self.roomId
            self.roomId = data
            self.setupData()
        }
    }
}

extension AskHomeViewController: UISearchBarDelegate {
    private func searchBarInit() {
        self.searchBar.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        guard let text = self.searchText else { return }
        
        if text != "" {
            let resultTopMessage = self.topMessages.filter { $0.content.range(of: text) != nil }
            self.topMessagesForShow = resultTopMessage
            
            let resultMessage = self.messages.filter { $0.content.range(of: text) != nil }
            self.messagesForShow = resultMessage
        } else {
            self.topMessagesForShow = self.topMessages
            self.messagesForShow = self.messages
        }
        
//        self.messagesTableView.reloadSections(IndexSet([Section.topMessage.rawValue, Section.message.rawValue]), with: .automatic)
        self.messagesTableView.reloadData()
    }
    
    @objc func tapBackground(_ sender: UITapGestureRecognizer?) {
        self.searchBar.resignFirstResponder()
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
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.adjustKeyboardDismisTapGesture(isKeyboardVisible: false)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        scrollView.contentOffset.y = offsetY > 0 ? offsetY : 0
    }
}

extension AskHomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
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
            return self.topMessagesForShow.count
        case .messageHeader:
            return 1
        case .message:
            return self.messagesForShow.count
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
            cell.configure(indexPath.row + 1, data: self.topMessagesForShow[indexPath.row])
            cell.setSearchText(self.searchText ?? "")
            return cell
        case .message:
            let cell = tableView.dequeue(MessageTableViewCell.self, for: indexPath)
            let index = self.messagesForShow.count - indexPath.row - 1
            cell.configure(self.messagesForShow[index])
            cell.setSearchText(self.searchText ?? "")
            return cell
        }
    }
}
