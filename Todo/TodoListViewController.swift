//
//  TodoListViewController.swift
//  Todo
//
//  Created by 홍정민 on 7/2/24.
//

import UIKit

class TodoListViewController: BaseViewController {
    
    override func configureUI() {
        let add = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonClicked))
        navigationItem.leftBarButtonItem = add
    }
    
    @objc
    func addButtonClicked(){
        let addTodoVC = UINavigationController(rootViewController: AddTodoViewController())
        addTodoVC.modalPresentationStyle = .fullScreen
        present(addTodoVC, animated: true)
    }
}
