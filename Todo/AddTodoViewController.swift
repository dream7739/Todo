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
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "todoCell")
        tableView.register(TodoTitleTableViewCell.self, forCellReuseIdentifier: TodoTitleTableViewCell.identifier)
        tableView.register(TodoContentTableViewCell.self, forCellReuseIdentifier: TodoContentTableViewCell.identifier)
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell")!
            cell.textLabel?.text = Display.TodoTitle.allCases[indexPath.section].rawValue
            cell.accessoryType = .disclosureIndicator
            return cell
        }else{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: TodoTitleTableViewCell.identifier, for: indexPath)
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: TodoContentTableViewCell.identifier, for: indexPath)
                cell.selectionStyle = .none
                return cell
            }
        }
        
    }
}
