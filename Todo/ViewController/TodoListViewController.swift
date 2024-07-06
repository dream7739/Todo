//
//  TodoListViewController.swift
//  Todo
//
//  Created by 홍정민 on 7/2/24.
//

import UIKit
import RealmSwift
import SnapKit
import Toast

final class TodoListViewController: BaseViewController {
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    
    private let repository = RealmRepository()
    private var list: Results<Todo>!
    var option: MainOption!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list = repository.fetchList(option)
        configureTableView()
        configureMenu()
        
        print(try! Realm().configuration.fileURL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveTodoComplete),
            name: Notification.Name.saveTodo,
            object: nil
        )
    }
    
    @objc func saveTodoComplete(){
        view.makeToast("할 일이 저장되었습니다")
    }
    
    override func configureHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        navigationItem.title = option.rawValue
        navigationController?.navigationBar.prefersLargeTitles = true
        searchBar.delegate = self
    }

   
}

extension TodoListViewController {
    
    private func configureTableView(){
        tableView.rowHeight = 85
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            TodoListTableViewCell.self,
            forCellReuseIdentifier: TodoListTableViewCell.identifier
        )
    }
    
    private func configureMenu(){
        let total = UIAction(title: SortMenuOption.total.rawValue) { _ in
            self.list = self.repository.fetchList(self.option, .total)
            self.tableView.reloadData()
            if !self.list.isEmpty {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
        
        let title = UIAction(title: SortMenuOption.title.rawValue){ _ in
            self.list = self.repository.fetchList(self.option, .title)
            self.tableView.reloadData()
            if !self.list.isEmpty {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
        
        let deadLine = UIAction(title: SortMenuOption.deadLine.rawValue){ _ in
            self.list = self.repository.fetchList(self.option, .deadLine)
            self.tableView.reloadData()
            if !self.list.isEmpty {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
        
        let high = UIAction(title: SortMenuOption.high.rawValue){ _ in
            self.list = self.repository.fetchList(self.option, .priority(.high))
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        
        let middle = UIAction(title: SortMenuOption.medium.rawValue){ _ in
            self.list = self.repository.fetchList(self.option, .priority(.medium))
            self.tableView.reloadData()
            if !self.list.isEmpty {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
        
        let row = UIAction(title: SortMenuOption.row.rawValue){ _ in
            self.list = self.repository.fetchList(self.option, .priority(.row))
            self.tableView.reloadData()
            if !self.list.isEmpty {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }

        let priority = UIMenu(
            title: SortMenuOption.priority.rawValue,
            children: [high, middle, row]
        )
        
        let menu = UIMenu(
            title: "",
            options: .displayInline,
            children: [total, title, deadLine, priority]
        )
        
        let sort = UIBarButtonItem(
            image: Design.Image.sort,
            menu: menu
        )
        
        navigationItem.rightBarButtonItem = sort

    }
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchText.trimmingCharacters(in: .whitespaces)
        
        if text.isEmpty {
            list = repository.fetchList()
        }else{
            list = repository.fetchList(text)
        }
        
        tableView.reloadData()
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
        cell.configureData(data)
      
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

        pin.image = Design.Image.pin
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
            self.showAlert("알림", "정말 삭제하시겠습니까?", "확인") { _ in
                let item = self.list[indexPath.row]
                self.removeImageFromDocument(filename: "\(item.id)")
                self.repository.deleteTodo(item)
                tableView.deleteRows(at: [indexPath], with: .none)
            }
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
