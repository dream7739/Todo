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
    
    let repository = RealmRepository()
    var option: Display.MainOption!
    var list: Results<Todo>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        list = repository.fetchList(option)
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
        navigationItem.title = option.rawValue
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let total = UIAction(title: "전체", handler: { _ in
            self.list = self.repository.fetchList(self.option)
            self.tableView.reloadData()
        })
        
        let title = UIAction(title: "제목순", handler: { _ in
            let sortProperties = [
                SortDescriptor(keyPath: "isFavorite", ascending: false),
                SortDescriptor(keyPath: "title", ascending: true)
            ]
            self.list = self.repository.fetchList(self.option).sorted(by: sortProperties)
            self.tableView.reloadData()
        })
        
        let deadLine = UIAction(title: "마감일순", handler: { _ in
            let sortProperties = [
                SortDescriptor(keyPath: "isFavorite", ascending: false),
                SortDescriptor(keyPath: "deadLine", ascending: false)
            ]
            self.list = self.repository.fetchList(self.option).sorted(by: sortProperties)
            self.tableView.reloadData()
        })
        
        let high = UIAction(title: "높음", handler: { _ in
            let sortProperties = [
                SortDescriptor(keyPath: "isFavorite", ascending: false)
            ]
            self.list = self.repository.fetchList(self.option).where { $0.priority == "높음"}.sorted(by: sortProperties)
            self.tableView.reloadData()
        })
        
        
        let middle = UIAction(title: "보통", handler: { _ in
            let sortProperties = [
                SortDescriptor(keyPath: "isFavorite", ascending: false)
            ]
            self.list = self.repository.fetchList(self.option).where{ $0.priority == "보통"}.sorted(by: sortProperties)
            self.tableView.reloadData()
        })
        
        
        let row = UIAction(title: "낮음", handler: { _ in
            let sortProperties = [
                SortDescriptor(keyPath: "isFavorite", ascending: false)
            ]
            self.list = self.list.where { $0.priority == "낮음"}.sorted(by: sortProperties)
            self.tableView.reloadData()
        })

        let priority = UIMenu(title: "우선순위", children: [high, middle, row])
        
        let menu = UIMenu(title: "", options: .displayInline, children: [total, title, deadLine, priority])
        let sort = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: menu)
        navigationItem.rightBarButtonItem = sort

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
}

extension TodoListViewController: CompletDelegate {
    func completeButtonClicked(indexPath: IndexPath) {
        let item = list[indexPath.row]
        var isComplete = item.isComplete
        isComplete.toggle()
        repository.editIsComplete(list[indexPath.row], isComplete: isComplete)
        tableView.reloadRows(at: [indexPath], with: .none)
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
        cell.delegate = self
        cell.indexPath = indexPath
        cell.isCompleteClicked = data.isComplete
        cell.contentLabel.text = data.content
        
        if let deadLine = data.deadLine {
            let dataFormatter = DateFormatter()
            dataFormatter.dateFormat = "yyyy.MM.dd."
            cell.deadlineLabel.text = dataFormatter.string(for: deadLine)
        }else{
            cell.deadlineLabel.isHidden = true
        }
        
        if let tag = data.hashTag {
            cell.tagLabel.text = "#" + tag
        }
        
        let titleText = data.title
        
        if let priority = data.priority {
            if priority == "높음" {
                cell.titleLabel.text = "⭐️⭐️⭐️ " + data.title
            }else if priority == "보통"{
                cell.titleLabel.text = "⭐️⭐️ " + titleText
            }else{
                cell.titleLabel.text = "⭐️ " + titleText
            }
        }else{
            cell.titleLabel.text = titleText
        }
        
        cell.pinImage.isHidden = data.isFavorite ? false : true
        cell.flagImage.isHidden = data.isFlaged ? false : true

        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pin = UIContextualAction(style: .normal, title: "") { view, _, completion in
            let item = self.list[indexPath.row]
            var isFavorite = item.isFavorite
            isFavorite.toggle()
            
            self.repository.editIsFavorite(item, isFavorite: isFavorite)
            tableView.reloadData()
            completion(true)
        }

        pin.image = UIImage(systemName: "pin.fill")
        return UISwipeActionsConfiguration(actions: [pin])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let flag = UIContextualAction(style: .normal, title: "깃발") { _, _, completion in
            let item = self.list[indexPath.row]
            var isFlaged = item.isFlaged
            isFlaged.toggle()
            self.repository.editIsFlaged(item, isFlaged: isFlaged)
            tableView.reloadData()
            completion(true)
        }
        
        flag.backgroundColor = .orange
        
        let delete = UIContextualAction(style: .destructive, title: "삭제") { _, _, completion in
            let item = self.list[indexPath.row]
            self.removeImageFromDocument(filename: "\(item.id)")
            self.repository.deleteTodo(item)
            tableView.deleteRows(at: [indexPath], with: .none)
            completion(true)
            
        }
        
        return UISwipeActionsConfiguration(actions: [delete, flag])
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addTodoVC = AddTodoViewController()
        let item = list[indexPath.row]
        addTodoVC.viewType = .editTodo
        addTodoVC.item = item
 
        navigationController?.pushViewController(addTodoVC, animated: true)
        
    }
    
}
