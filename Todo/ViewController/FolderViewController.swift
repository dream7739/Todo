//
//  FolderViewController.swift
//  Todo
//
//  Created by 홍정민 on 7/8/24.
//

import UIKit
import RealmSwift
import SnapKit
import Toast

final class FolderViewController: BaseViewController {
    
    private let tableView = UITableView()
    private let repository = RealmRepository()
    var list: Results<Folder>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "사용자 지정"
        
        repository.detectRealmURL()
        list = repository.fetchFolder()
        
        if list.isEmpty {
            repository.addFolder()
        }
        
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
    
}

extension FolderViewController {
    private func configureTableView(){
        tableView.rowHeight = 85
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "folderCell"
        )
    }
}


extension FolderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "folderCell")
        
        let data = list[indexPath.row]
        cell.textLabel?.text = data.name
        cell.detailTextLabel?.text = "\(data.detail.count)개의 할 일"
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "삭제") { _, _, completion in
            self.showAlert("알림", "정말 삭제하시겠습니까?", "확인") { _ in
//                let item = self.list[indexPath.row]
//                self.removeImageFromDocument(filename: "\(item.id)")
//                self.repository.deleteTodo(item)
//                tableView.deleteRows(at: [indexPath], with: .none)
                completion(true)
            }
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = list[indexPath.row] //폴더 정보
        let folderTodoListVC = FolderTodoListViewController()
        folderTodoListVC.folder = data
        navigationController?.pushViewController(folderTodoListVC, animated: true)
    }
    
}
