//
//  TodoListViewController.swift
//  Todo
//
//  Created by 홍정민 on 7/2/24.
//

import UIKit
import SnapKit
import RealmSwift

final class TodoListViewController: BaseViewController {
    
    private let tableView = UITableView()

    private var list: Results<Todo>!
    
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list =  realm.objects(Todo.self)
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
        let add = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(addButtonClicked)
        )
        
        let sort = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: self,
            action: nil
        )
        
        let title = UIAction(title: "제목순", handler: { _ in
            self.list = self.realm.objects(Todo.self).sorted(byKeyPath: "title", ascending: true)
            self.tableView.reloadData()
        })
        
        
        let deadLine = UIAction(title: "마감일순", handler: { _ in
            self.list = self.realm.objects(Todo.self).sorted(byKeyPath: "deadLine", ascending: true)
            self.tableView.reloadData()
        })
        
        let buttonMenu = UIMenu(title: "", children: [title, deadLine])
        sort.menu = buttonMenu
        
        navigationItem.leftBarButtonItem = add
        navigationItem.rightBarButtonItem = sort
        navigationItem.title = "전체"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func configureTableView(){
        tableView.rowHeight = 85
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            TodoListTableViewCell.self,
            forCellReuseIdentifier: TodoListTableViewCell.identifier
        )
    }
    
    @objc
    private func addButtonClicked(){
        let addTodoVC = UINavigationController(rootViewController: AddTodoViewController())
        addTodoVC.modalPresentationStyle = .fullScreen
        present(addTodoVC, animated: true)
    }
}

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoListTableViewCell.identifier) as! TodoListTableViewCell
        let data = list[indexPath.row]
        cell.titleLabel.text = data.title
        cell.contentLabel.text = data.content
        
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "yyyy.MM.dd"
        cell.deadlineLabel.text = dataFormatter.string(for: data.deadLine)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "삭제") { _, _, completion in
            try! self.realm.write {
                self.realm.delete(self.list[indexPath.row])
            }
            
            tableView.deleteRows(at: [indexPath], with: .none)
            completion(true)
            
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
 
    
}
