//
//  TodoListViewController.swift
//  Todo
//
//  Created by 홍정민 on 7/2/24.
//

import UIKit
import SnapKit
import RealmSwift

class TodoListViewController: BaseViewController {
    
    let tableView = UITableView()

    var list: Results<Todo>!
    
    let realm = try! Realm()
    
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
        let add = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonClicked))
        navigationItem.leftBarButtonItem = add
        navigationItem.title = "전체"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTableView(){
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TodoListTableViewCell.self, forCellReuseIdentifier: TodoListTableViewCell.identifier)
    }
    
    @objc
    func addButtonClicked(){
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
        dataFormatter.dateFormat = "yyyy-MM-dd"
        cell.deadlineLabel.text = dataFormatter.string(for: data.deadLine)
        return cell
    }
    
 
    
}
