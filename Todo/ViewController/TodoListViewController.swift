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
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    
    let repository = RealmRepository()
    var option: TodoMainViewController.MainOption!
    var list: Results<Todo>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list = repository.fetchList(option)
        configureTableView()
        configureMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
    enum SortOption: String {
        case total = "전체"
        case title = "제목순"
        case deadLine = "마감일순"
        case priority = "우선순위순"
        case high = "높음"
        case medium = "보통"
        case row = "낮음"
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
    
    private func configureMenu(){
        let total = UIAction(title: SortOption.total.rawValue) { _ in
            self.list = self.repository.fetchList(self.option, .total)
            self.tableView.reloadData()
        }
        
        let title = UIAction(title: SortOption.title.rawValue){ _ in
            self.list = self.repository.fetchList(self.option, .title)
            self.tableView.reloadData()
        }
        
        let deadLine = UIAction(title: SortOption.deadLine.rawValue){ _ in
            self.list = self.repository.fetchList(self.option, .deadLine)
            self.tableView.reloadData()
        }
        
        let high = UIAction(title: SortOption.high.rawValue){ _ in
            self.list = self.repository.fetchList(self.option, .priority(.high))
            self.tableView.reloadData()
        }
        
        let middle = UIAction(title: SortOption.medium.rawValue){ _ in
            self.list = self.repository.fetchList(self.option, .priority(.medium))
            self.tableView.reloadData()
        }
        
        let row = UIAction(title: SortOption.row.rawValue){ _ in
            self.list = self.repository.fetchList(self.option, .priority(.row))
            self.tableView.reloadData()
        }

        let priority = UIMenu(
            title: SortOption.priority.rawValue,
            children: [high, middle, row]
        )
        
        let menu = UIMenu(
            title: "",
            options: .displayInline,
            children: [total, title, deadLine, priority]
        )
        
        let sort = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            menu: menu
        )
        
        navigationItem.rightBarButtonItem = sort

    }
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //print(searchText)
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
