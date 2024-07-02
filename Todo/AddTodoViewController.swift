//
//  AddTodoViewController.swift
//  Todo
//
//  Created by 홍정민 on 7/2/24.
//

import UIKit
import SnapKit
import RealmSwift

class AddTodoViewController: BaseViewController {
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    var selectedDate: Date?
    
    let realm = try! Realm()
    
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
    
    @objc
    func cancelButtonClicked(){
        dismiss(animated: true)
    }
    
    
    @objc
    func addButtonClicked(){
        let titleItem = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TodoTitleTableViewCell
        let contentItem = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TodoContentTableViewCell
        let title = titleItem.titleTextField.text!.trimmingCharacters(in: .whitespaces)
        let content = contentItem.contentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let todo = Todo(title: title, content: content, deadLine: selectedDate)

        try! realm.write {
            realm.add(todo)
            print("SUCCESS")
            print(realm.configuration.fileURL)
            self.dismiss(animated: true)
        }
    }
}

extension AddTodoViewController {
    @objc func titleTextFieldChanged(sender: UITextField){
        guard let title = sender.text?.trimmingCharacters(in: .whitespaces), title.isEmpty else{
            navigationItem.rightBarButtonItem?.isEnabled = true
            return
        }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
}


extension AddTodoViewController: UITableViewDelegate, UITableViewDataSource {
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
                cell.detailTextLabel?.text = "\(selectedDate)"
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let todoDateVC = TodoDateViewController()
            todoDateVC.dateSender = { date in
                self.selectedDate = date
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
            }
            navigationController?.pushViewController(todoDateVC, animated: true)
        }
    }
}
