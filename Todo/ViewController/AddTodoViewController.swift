//
//  AddTodoViewController.swift
//  Todo
//
//  Created by 홍정민 on 7/2/24.
//

import UIKit
import SnapKit
import RealmSwift

protocol TagTextSendDelegate: AnyObject {
    func tagTextSend(_ text: String)
}

final class AddTodoViewController: BaseViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private var selectedDate: Date?
    
    private var tagText: String?
    
    private var priorityText: String?
    
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(receivePriority), name: NSNotification.Name("sendPriority"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            if let _ = self.selectedDate {
                self.tableView.reloadRows(
                    at: [IndexPath(row: 0, section: 1)],
                    with: .none
                )
            }
            
            if let _ = self.tagText {
                self.tableView.reloadRows(
                    at: [IndexPath(row: 0, section: 2)],
                    with: .none
                )
            }
            
            if let _ = self.priorityText {
                self.tableView.reloadRows(
                    at: [IndexPath(row: 0, section: 3)],
                    with: .none
                )
            }
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        navigationItem.title = "새로운 할 일"
        
        let cancel = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonClicked))
        
        let add = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addButtonClicked))
        
        navigationItem.leftBarButtonItem = cancel
        navigationItem.rightBarButtonItem = add
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "todoCell")
        tableView.register(TodoTitleTableViewCell.self, forCellReuseIdentifier: TodoTitleTableViewCell.identifier)
        tableView.register(TodoContentTableViewCell.self, forCellReuseIdentifier: TodoContentTableViewCell.identifier)
    }
    
}

extension AddTodoViewController {
    @objc
    private func cancelButtonClicked(){
        dismiss(animated: true)
    }
    
    @objc
    private func addButtonClicked(){
        let titleItem = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TodoTitleTableViewCell
        let contentItem = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TodoContentTableViewCell
        let title = titleItem.titleTextField.text!.trimmingCharacters(in: .whitespaces)
        let content = contentItem.contentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let todo = Todo(title: title, content: content, deadLine: selectedDate)
        
        try! realm.write {
            realm.add(todo)
            self.dismiss(animated: true)
        }
    }
    
    @objc
    private func titleTextFieldChanged(sender: UITextField){
        
        guard let title = sender.text?.trimmingCharacters(in: .whitespaces), title.isEmpty else{
            navigationItem.rightBarButtonItem?.isEnabled = true
            return
        }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc
    private func receivePriority(notification: NSNotification){
        guard let text = notification.userInfo?["priority"] as? String else { return }
        priorityText = text
    }
    
}

extension AddTodoViewController: TagTextSendDelegate {
    func tagTextSend(_ text: String) {
        tagText = text
    }
}

extension AddTodoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 1{
            return 130
        }
        
        return 44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Display.TodoTitle.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (1...4).contains(indexPath.section){
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "todoCell")
            cell.textLabel?.text = Display.TodoTitle.allCases[indexPath.section].rawValue
            cell.accessoryType = .disclosureIndicator
            
            if let selectedDate, indexPath.section == 1 {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy.MM.dd"
                cell.detailTextLabel?.text = dateFormatter.string(from: selectedDate)
            }
            
            if let tagText, indexPath.section == 2 {
                cell.detailTextLabel?.text = tagText
            }
            
            if let priorityText, indexPath.section == 3 {
                cell.detailTextLabel?.text = priorityText
            }
            
            return cell
        }else{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: TodoTitleTableViewCell.identifier, for: indexPath) as! TodoTitleTableViewCell
                cell.selectionStyle = .none
                cell.titleTextField.addTarget(self, action: #selector(titleTextFieldChanged), for: .editingChanged)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: TodoContentTableViewCell.identifier, for: indexPath)
                cell.selectionStyle = .none
                return cell
            }
        }
    }
    
    //1: 날짜,  2. 태그, 3: 우선순위, 4: 이미지
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            let todoDateVC = TodoDateViewController()
            todoDateVC.dateSender = { date in
                self.selectedDate = date
            }
            navigationController?.pushViewController(todoDateVC, animated: true)
        case 2:
            let todoTagVC = TodoTagViewController()
            todoTagVC.delegate = self
            if let tagText {
                todoTagVC.editTagText = tagText
            }
            navigationController?.pushViewController(todoTagVC, animated: true)
        case 3:
            let todoPriorityVC = TodoPriorityViewController()
            navigationController?.pushViewController(todoPriorityVC, animated: true)
        default:
            return
        }
    }
}

